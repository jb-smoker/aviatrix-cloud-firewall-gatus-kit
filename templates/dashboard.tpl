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

sudo cat > config.yaml << EOL
ui:
  header: "${cloud} gatus dashboard"
  logo: "https://aviatrix.com/wp-content/uploads/2023/03/1-1024x1024.png"
  link: "https://aviatrix.com/aviatrix-paas"
  title: "${cloud}"
web:
  port: 8080
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

sudo docker run -d --restart unless-stopped --name gatus -p 80:8080 --mount type=bind,source=/config.yaml,target=/config/config.yaml twinproduction/gatus:v${version}
