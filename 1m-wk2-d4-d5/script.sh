#! /bin/bash

# Setup python virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Install ansible dependencies
ansible-galaxy collection install community.general
ansible-galaxy collection install datadog.dd

# View discovered hosts
ansible-inventory --graph

# Run playbook for webserver setup
ansible-playbook webserver.yml

# Run playbook for proxy setup
ansible-playbook fetch-ips.yml
ansible-playbook proxy.yml
