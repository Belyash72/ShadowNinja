import time
import sqlite3
import json
import subprocess
from uuid import uuid4
from io import BytesIO

from aiogram import Bot, Dispatcher, types, F
from aiogram.enums import ParseMode
from aiogram.client.default import DefaultBotProperties
from aiogram.types import (
    Message,
    InlineKeyboardMarkup,
    InlineKeyboardButton,
    BufferedInputFile,
)

import qrcode

# Ensure subprocess import is recognized by linting tools
subprocess.DEVNULL

# === НАСТРОЙКИ ===
BOT_TOKEN = '8156945280:AAH8OzlppYm9T12vaqHIIiqEjGgO8Fui3ss'
XUI_DB_PATH = "/etc/x-ui/x-ui.db"
VLESS_ADDRESS = "217.145.79.217"
VLESS_PORT = 44301
VLESS_PATH = ""
VLESS_SECURITY = "none"
VLESS_TRANSPORT = "tcp"
VLESS_TAG = "master"

# === TELEGRAM ===
bot = Bot(token=BOT_TOKEN, default=DefaultBotProperties(parse_mode=ParseMode.HTML))
dp = Dispatcher()

# === ВРЕМЕННОЕ СОСТОЯНИЕ (пользователь ждёт email) ===
pending_email_users = {}

# === КНОПКИ ===
def main_menu():
    return InlineKeyboardMarkup(
        inline_keyboard=[
            [InlineKeyboardButton(text="🔐 Получить VPN", callback_data="getvpn")],
            [InlineKeyboardButton(text="🚫 Отозвать доступ", callback_data="revoke")]
        ]
    )

def ask_email_keyboard():
    return InlineKeyboardMarkup(
        inline_keyboard=[
            [InlineKeyboardButton(text="📧 Указать почту", callback_data="enter_email")],
            [InlineKeyboardButton(text="🚫 Пропустить", callback_data="skip_email")]
        ]
    )

def cancel_email_keyboard():
    return InlineKeyboardMarkup(
        inline_keyboard=[
            [InlineKeyboardButton(text="❌ Отмена", callback_data="cancel_email")]
        ]
    )

# === QR-КОД ===
def generate_qr_code(link: str) -> BytesIO:
    img = qrcode.make(link)
    bio = BytesIO()
    bio.name = "vpn_qr.png"
    img.save(bio, "PNG")
    bio.seek(0)
    return bio

# === /start ===
@dp.message(F.text == "/start")
async def start_handler(message: Message):
    await message.answer("👋 Добро пожаловать!\nНажми кнопку ниже, чтобы получить VPN-доступ:", reply_markup=main_menu())

# === КНОПКА: 🔐 Получить VPN ===
@dp.callback_query(F.data == "getvpn")
async def handle_getvpn(callback: types.CallbackQuery):
    await callback.answer()
    await callback.message.answer(
        "Хочешь указать email?\n📧 Это поможет восстановить доступ в будущем.\n\nМожешь написать email или нажать «Пропустить»:",
        reply_markup=ask_email_keyboard()
    )

# === КНОПКА: 🚫 Отозвать доступ ===
@dp.callback_query(F.data == "revoke")
async def handle_revoke(callback: types.CallbackQuery):
    await callback.answer()
    tg_id = str(callback.from_user.id)

    try:
        conn = sqlite3.connect(XUI_DB_PATH)
        cursor = conn.cursor()
        cursor.execute("SELECT id, settings FROM inbounds LIMIT 1")
        row = cursor.fetchone()
        if not row:
            await callback.message.answer("❌ Не найден инбаунд в базе x-ui.")
            return

        inbound_id, settings_json = row
        settings = json.loads(settings_json)
        original_len = len(settings.get("clients", []))
        settings["clients"] = [c for c in settings["clients"] if c.get("tgId") != tg_id]

        if len(settings["clients"]) == original_len:
            await callback.message.answer("ℹ️ У тебя не было активного VPN-доступа.")
            return

        cursor.execute("UPDATE inbounds SET settings = ? WHERE id = ?", (json.dumps(settings), inbound_id))
        conn.commit()
        await callback.message.answer("✅ Твой VPN-доступ был отозван.")
    except Exception as e:
        await callback.message.answer("❌ Ошибка при удалении клиента.")
        print(f"Ошибка при revoke: {e}")
    finally:
        if 'conn' in locals():
            conn.close()


# === КНОПКА: 📧 Указать почту ===
@dp.callback_query(F.data == "enter_email")
async def handle_enter_email(callback: types.CallbackQuery):
    pending_email_users[callback.from_user.id] = "waiting_email"
    await callback.answer()
    await callback.message.answer(
        "✉️ Введите вашу почту:",
        reply_markup=cancel_email_keyboard()
    )

# === КНОПКА: 🚫 Пропустить ===
@dp.callback_query(F.data == "skip_email")
async def handle_skip_email(callback: types.CallbackQuery):
    await callback.answer("Пропущено")
    await generate_vpn(callback.message, email="")

# === КНОПКА: ❌ Отмена ===
@dp.callback_query(F.data == "cancel_email")
async def handle_cancel_email(callback: types.CallbackQuery):
    pending_email_users.pop(callback.from_user.id, None)
    await callback.answer("Отменено")
    await generate_vpn(callback.message, email="")

# === Ввод email (обычное сообщение) ===
@dp.message()
async def handle_possible_email(message: Message):
    user_id = message.from_user.id
    if pending_email_users.get(user_id) == "waiting_email":
        pending_email_users.pop(user_id)
        email = message.text.strip()
        await generate_vpn(message, email=email)

# === Генерация VPN-доступа ===
async def generate_vpn(message: Message, email: str = ""):
    tg_id = str(message.from_user.id)
    client_tag = f"tg_{tg_id}"

    try:
        conn = sqlite3.connect(XUI_DB_PATH)
        cursor = conn.cursor()
        cursor.execute("SELECT id, settings FROM inbounds LIMIT 1")
        row = cursor.fetchone()
        if not row:
            await message.answer("❌ Не удалось найти инбаунд в базе x-ui.")
            return

        inbound_id, settings_json = row
        settings = json.loads(settings_json)
        clients = settings.get("clients", [])

        existing = next((c for c in clients if c.get("tgId") == tg_id), None)

        if existing:
            uuid = existing["id"]
        else:
            uuid = str(uuid4())
            expiry = int((time.time() + 365 * 24 * 60 * 60) * 1000)  # 1 год
            new_client = {
                "id": uuid,
                "email": email,
                "enable": True,
                "expiryTime": expiry,
                "limitIp": 0,
                "reset": 0,
                "totalGB": 0,
                "subId": "",
                "tgId": tg_id,
                "flow": "",
                "comment": ""
            }

            clients.append(new_client)
            settings["clients"] = clients
            cursor.execute("UPDATE inbounds SET settings = ? WHERE id = ?", (json.dumps(settings), inbound_id))
            conn.commit()
            # Перезапускаем x-ui (чтобы xray подхватил нового пользователя)
            subprocess.run(["x-ui", "restart"])

        # Сборка ссылки
        config_url = f"vless://{uuid}@{VLESS_ADDRESS}:{VLESS_PORT}?type={VLESS_TRANSPORT}&path={VLESS_PATH}&security={VLESS_SECURITY}#{VLESS_TAG}-{client_tag}"
        await message.answer(
            f"✅ Доступ предоставлен на <b>1 год</b>.\n\n"
            f"📲 Скопируй эту ссылку и вставь в приложение <b>Amnezia</b>:\n"
            f"<code>{config_url}</code>"
        )

        qr = generate_qr_code(config_url)
        await message.answer_photo(
            photo=BufferedInputFile(qr.read(), filename="vpn_qr.png"),
            caption="📱 Отсканируй QR-код для подключения"
        )

    except Exception as e:
        await message.answer("❌ Ошибка при работе с базой x-ui.")
        print(f"Ошибка: {e}")
    finally:
        if 'conn' in locals():
            conn.close()

# === ЗАПУСК ===
if __name__ == '__main__':
    import asyncio
    asyncio.run(dp.start_polling(bot))
