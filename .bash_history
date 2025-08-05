apt update && apt install -y curl
bash <(curl -fsSL https://raw.githubusercontent.com/amnezia-vpn/amnezia-server/master/install.sh)
bash <(curl -sSL https://raw.githubusercontent.com/amnezia-vpn/amnezia-wg-installer/main/install.sh)
apt update && apt upgrade -y
apt install -y ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker --version
apt install -y git
git clone https://github.com/amnezia-vpn/amnezia-server.git
git clone https://ghproxy.com/https://github.com/amnezia-vpn/amnezia-server.git
wget https://github.com/amnezia-vpn/amnezia-server/archive/refs/heads/master.zip -O amnezia.zip
docker ps
docker stop $(docker ps -q)
docker ps
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
wget https://files.catbox.moe/c7cz68.zip -O amnezia.zip
apt install -y git
git clone https://github.com/nokitakaze/AmneziaVPNDockerServer.git
cd AmneziaVPNDockerServer
docker compose up -d
docker ps
cd ~/AmneziaVPNDockerServer#
 cd ~/AmneziaVPNDockerServer
docker exec -it amneziavpndockerserver-ssh-service-1 bash
mkdir -p /root/amnezia-gen
cd /root/amnezia-gen
nano generate.sh
chmod +x generate.sh
/root/amnezia-gen/generate.sh
apt update && apt install -y python3 python3-pip
pip3 install aiogram
apt install -y python3-venv python3-full
python3 -m venv venv
source venv/bin/activate
pip install aiogram
cd /root/amnezia-gen
ls
nano bot.py
source venv/bin/activate
python bot.py
nano /etc/systemd/system/amnezia-bot.service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable amnezia-bot.service
systemctl start amnezia-bot.service
systemctl status amnezia-bot.service
cat /root/amnezia-gen/generate.sh
docker exec ssh-service /opt/amnezia/add-client
docker ps -a
docker exec amneziavpndockerserver-ssh-service-1 /opt/amnezia/add-client
docker exec -it amneziavpndockerserver-ssh-service-1 /bin/bash
docker rm amneziavpndockerserver-ssh-service-1
docker pull nokitakaze/amnezia-vpn-docker-server:ssh-service
docker pull nokitakaze/amneziavpndockerserver:ssh-service
docker rm -f amneziavpndockerserver-ssh-service-1
docker image rm amneziavpndockerserver-ssh-service
docker rm -f amneziavpndockerserver-ssh-service-1
docker image rm amneziavpndockerserver-ssh-service
root@shadowninja:~# docker pull nokitakaze/amneziavpndockerserver:ssh-service
Error response from daemon: pull access denied for nokitakaze/amneziavpndockerserver, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
root@shadowninja:~#
docker rm -f amneziavpndockerserver-ssh-service-1
docker image rm amneziavpndockerserver-ssh-service
git clone https://github.com/nokitakaze/AmneziaVPNDockerServer.git
cd AmneziaVPNDockerServer
docker compose -f docker-compose-ssh.yml up -d
docker ps
rm -rf ~/AmneziaVPNDockerServer
rm -rf ~/AmneziaVPNDockerServer
git clone https://github.com/nokitakaze/AmneziaVPNDockerServer.git
cd AmneziaVPNDockerServer
rm -rf ~/AmneziaVPNDockerServer
git clone https://github.com/nokitakaze/AmneziaVPNDockerServer.git
cd AmneziaVPNDockerServer
ls -la
git checkout release
ls -la
cat docker-compose.yml
rm docker-compose.yml
nano docker-compose.yml
 cat docker-compose.yml
docker compose up -d
nano docker-compose.yml
docker-compose down
docker-compose pull
docker-compose up -d
nano docker-compose.yml
docker compose up -d
nano docker-compose.yml
image: nokitakaze/amnezia-vpn-server
nano docker-compose.yml
docker compose pull
docker compose up -d
docker ps
docker exec ssh-service /opt/amnezia/add-client
docker ps --filter=name=amnezia
docker compose run --rm ssh-service add-client
wget https://raw.githubusercontent.com/nokitakaze/AmneziaVPNDockerServer/master/docker-compose-ssh.yml
docker compose -f docker-compose-ssh.yml up -d
docker exec ssh-service /opt/amnezia/add-client
exit
cd ~
git clone https://github.com/nokitakaze/AmneziaCLI.git
cd AmneziaCLI
nano /root/amnezia-gen/generate.sh
chmod +x /root/amnezia-gen/generate.sh
/root/amnezia-gen/generate.sh
docker ps -aq | xargs -r docker stop
docker ps -aq | xargs -r docker rm
docker images -aq | xargs -r docker rmi -f
rm -rf ~/AmneziaVPNDockerServer
rm -rf ~/AmneziaCLI
rm -rf ~/amnezia-gen
rm -rf ~/venv
rm -f ~/bot.py
ls -l ~ | grep -E "Amnezia|bot|venv"
docker --version
apt install -y python3 python3-venv python3-pip
cd ~
python3 -m venv venv
source ~/venv/bin/activate
cd ~
git clone https://github.com/nokitakaze/AmneziaVPNDockerServer.git
cd AmneziaVPNDockerServer
docker compose -f docker-compose-ssh.yml up -d
wget https://raw.githubusercontent.com/nokitakaze/AmneziaVPNDockerServer/master/docker-compose-ssh.yml
nano docker-compose.yml
docker compose up -d
docker ps
mkdir -p ~/amnezia-gen
cd ~/amnezia-gen
nano generate.sh
chmod +x generate.sh
./generate.sh
pip show aiogram
pip install aiogram
pip show aiogram
nano ~/bot.py
python ~/bot.py
nano ~/bot.py
nano ~/bot.py
python ~/bot.py
nano ~/bot.py
python ~/bot.py
ps aux | grep bot.py
kill -9 50331
curl https://api.telegram.org/bot8156945280:AAH8OzlppYm9T12vaqHIIiqEjGgO8Fui3ss/deleteWebhook
python ~/bot.py
nohup python ~/bot.py > ~/bot.log 2>&1 &
ps aux | grep bot.py
cd ~
git clone https://github.com/nokitakaze/AmneziaCLI.git
cd AmneziaCLI
kill -9 12345
pkill -f bot.py
ps aux | grep bot.py
kill -9 51844 51861
ps aux | grep bot.py
pkill -f bot.py
ps aux | grep bot.py
kill -9 52424
nohup python ~/bot.py > ~/bot.log 2>&1 &
ps aux | grep bot.py
python3 amnezia_cli.py add-client --host 31.56.146.250
cd ~
rm -rf AmneziaCLI
git clone https://github.com/amnezia-vpn/AmneziaCLI.git
cd AmneziaCLI
git clone https://github.com/amnezia-vpn/AmneziaCLI.git --depth=1
git clone git://github.com/amnezia-vpn/AmneziaCLI.git
cd ~
rm -rf AmneziaCLI
git clone https://github.com/amnezia-vpn/AmneziaCLI.git --depth=1
cd AmneziaCLI
rm -rf ~/AmneziaCLI
rm -rf ~/AmneziaCLI
git clone git://github.com/amnezia-vpn/AmneziaCLI.git
cd ~
rm -rf AmneziaCLI
git clone https://github.com/amnezia-vpn/AmneziaCLI.git
cd ~
wget https://github.com/amnezia-vpn/AmneziaCLI/archive/refs/heads/master.zip -O AmneziaCLI.zip
wget https://github.com/amnezia-vpn/AmneziaCLI/archive/refs/heads/main.zip -O AmneziaCLI.zip
wget https://github.com/amnezia-vpn/AmneziaCLI/archive/refs/heads/main.zip
wget https://github.com/amnezia-vpn/AmneziaCLI/archive/refs/tags/v0.1.1.zip -O AmneziaCLI.zip
/root/amnezia-gen/generate.sh
docker ps
docker exec amneziavpndockerserver-ssh-service-1 python3 /opt/amnezia/scripts/add_user.py --export
docker exec amneziavpndockerserver-ssh-service-1 find /opt -name "*.py"
docker exec amneziavpndockerserver-ssh-service-1 find / -name "*.py"
docker exec -it amneziavpndockerserver-ssh-service-1 bash
wget -N https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh
chmod +x install.sh
./install.sh
x-ui
nano /root/amnezia-gen/generate.sh
nano bot.py
source /path/to/your/venv/bin/activate
source ~/venv/bin/activate
python bot.py
nano bot.py
python bot.py
ps aux | grep bot.py
kill -9 52445 66551 66609
kill -9 52445 66551
ps aux | grep bot.py
source ~/venv/bin/activate
python bot.py
x-ui -h
curl -s http://127.0.0.1:54321/api/system/config
pip install qrcode[pil]
ls -la ~ | grep venv
source ~/venv/bin/activate
pip install 'qrcode[pil]' aiogram
nano bot.py
python bot.py
nano /etc/systemd/system/vpnbot.service
python /root/bot.py
ls /root/bot.py
ls /root/venv/bin/python
nano /etc/systemd/system/vpnbot.service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable vpnbot
systemctl start vpnbot
systemctl status vpnbot
reboot
