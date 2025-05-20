#! /bin/bash
# Set logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
# Update packages
export DEBIAN_FRONTEND=noninteractive
sudo apt-get clean
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo apt-get install apache2-utils -y

echo "${cert}" | sudo tee -a /tmp/cert.crt
echo "${key}" | sudo tee -a /tmp/private.key

sudo cp /tmp/cert.crt /server.crt
sudo cp /tmp/private.key /server.key

bcrypt64="$(sudo htpasswd -bnBC 9 "" ${password} | tr -d ':\n' | sed 's/$2y/$2a/' | base64 -w 0)"

sudo cat > config.yaml << EOL
ui:
  header: "${cloud} gatus dashboard"
  logo: "https://aviatrix.com/wp-content/uploads/2023/03/1-1024x1024.png"
  link: "https://aviatrix.com"
  title: "${cloud}"
web:
  port: 8443
EOL

if [ "${password}" != "placeholder" ]; then
  sudo cat >> config.yaml << EOL
  tls:
    certificate-file: "/config/server.crt"
    private-key-file: "/config/server.key"
security:
  basic:
    username: "${user}"
    password-bcrypt-base64: "$bcrypt64"
EOL
fi

sudo cat >> config.yaml << EOL
endpoints:
  - name: aviatrix
    url: "https://www.aviatrix.com"
    interval: 60s
    group: aviatrix
    conditions:
      - "[STATUS] == 200"
remote:
  instances:
%{ for s in instances ~}
    - url: "http://${s}/api/v1/endpoints/statuses"
%{ endfor ~}
EOL

if [ "${password}" != "placeholder" ]; then
  sudo docker run -d --restart unless-stopped --name gatus -p 443:8443 --mount type=bind,source=/config.yaml,target=/config/config.yaml --mount type=bind,source=/server.crt,target=/config/server.crt --mount type=bind,source=/server.key,target=/config/server.key twinproduction/gatus:v${version}
else
  sudo docker run -d --restart unless-stopped --name gatus -p 80:8443 --mount type=bind,source=/config.yaml,target=/config/config.yaml twinproduction/gatus:v${version}
fi

