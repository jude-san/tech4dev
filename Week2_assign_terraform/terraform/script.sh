#! /bin/bash


sudo apt-get update -y
sudo apt-get install -y curl libxcrypt-compat


DD_API_KEY=9dc7523d32ea792a4cd75aa8cbee9d47 \
DD_SITE="datadoghq.eu" \
bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"

systemctl start datadog-agent
systemctl enable datadog-agent