#! /bin/bash
sudo grep -r PasswordAuthentication /etc/ssh -l | xargs -n 1 sudo sed -i 's/#\s*PasswordAuthentication\s.*$/PasswordAuthentication yes/; s/^PasswordAuthentication\s*no$/PasswordAuthentication yes/'
# Add local user
sudo adduser ${user}
sudo echo "${user}:${password}" | sudo /usr/sbin/chpasswd
sudo sed -i'' -e 's+\%sudo.*+\%sudo  ALL=(ALL) NOPASSWD: ALL+g' /etc/sudoers
sudo usermod -aG sudo ${user}
sudo service sshd restart
# Set logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
# Update packages
export DEBIAN_FRONTEND=noninteractive
sudo apt-get clean
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

sudo cat > config.yaml << EOL
ui:
  header: "${name}"
  logo: "https://aviatrix.com/wp-content/uploads/2023/03/1-1024x1024.png"
  link: "https://www.aviatrix.com"
  title: "${name}"
web:
  port: 8080
endpoints:
EOL

sudo cat >> config.yaml << EOL
%{ for s in https ~}
    - name: ${s}:443
      url: "https://${s}"
      client:
        insecure: false
        ignore-redirect: false
        timeout: 10s
      interval: ${interval}s
      group: "$(echo ${name} | sed 's/^[^-]*-//')"
      conditions:
      - "[STATUS] == 200"
%{ endfor ~}
%{ for s in http ~}
    - name: ${s}:80
      url: "http://${s}"
      client:
        insecure: false
        ignore-redirect: false
        timeout: 10s
      interval: ${interval}s
      group: "$(echo ${name} | sed 's/^[^-]*-//')"
      conditions:
      - "[STATUS] == 200"
%{ endfor ~}
%{ for s in icmp ~}
    - name: ping ${s}
      url: "icmp://${s}"
      client:
        insecure: false
        ignore-redirect: false
        timeout: 10s
      interval: ${interval}s
      group: "$(echo ${name} | sed 's/^[^-]*-//')"
      conditions:
      - "[CONNTECTED] == true"
%{ endfor ~}
%{ for s in tcp ~}
    - name: tcp ${s}
      url: "tcp://${s}"
      client:
        insecure: false
        ignore-redirect: false
        timeout: 10s
      interval: ${interval}s
      group: "$(echo "${name}" | sed 's/^[^-]*-//'"
      conditions:
      - "[CONNTECTED] == true"
%{ endfor ~}
EOL

sudo docker run -d --restart unless-stopped --name gatus -p 80:8080 --mount type=bind,source=/config.yaml,target=/config/config.yaml twinproduction/gatus:v${version}
