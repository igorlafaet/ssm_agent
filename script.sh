#!/bin/bash
#apt install -y jq
#apt install -y snap
#REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r`
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | cut -f2 -d ":" | sed 's/"//g' | sed 's/,//')
SO=$(cat /etc/*-release | grep -m1 "ID" | cut -f2 -d "=" | sed 's/"//g')
case $SO in
        "rhel")
        ## ----------------------------
        ## CentOS | Oracle Linux | RHEL
        ## ----------------------------

        ## Install AWS SSM Agent (Replace <region> with the region where your ec2 instance is hosted)
 
        URL=$(echo "https://s3.$REGION.amazonaws.com/amazon-ssm-$REGION/latest/linux_amd64/amazon-ssm-agent.rpm")
        yum install -y $URL

        ## Start and enable SSM agent
        systemctl start amazon-ssm-agent.service
        systemctl status amazon-ssm-agent.service
        systemctl enable amazon-ssm-agent.service
        ;;
        "amzn")
        ## --------------
        ## Amazon Linux 2
        ## --------------

        ## Install AWS SSM Agent (Replace <region> with the region where your ec2 instance is hosted)
        URL=$(echo "https://s3.$REGION.amazonaws.com/amazon-ssm-$REGION/latest/linux_amd64/amazon-ssm-agent.rpm")
        yum install -y $URL

        ## Start and enable SSM agent
        systemctl start amazon-ssm-agent.service
        systemctl status amazon-ssm-agent.service
        systemctl enable amazon-ssm-agent.service
        ;;
        "Ubuntu")
        VERSAO=$(cat /etc/*-release | grep -m1 "DISTRIB_RELEASE" | cut -f2 -d "=" | cut -f1 -d"." | sed 's/"//g')
        ## ------
        ## Ubuntu
        ## ------
        mkdir /tmp/ssm
        cd /tmp/ssm
        wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
        sudo dpkg -i amazon-ssm-agent.deb

        if [ $VERSAO -eq 14 ]; then
        sudo start amazon-ssm-agent


        elif [ $VERSAO -gt 14 ]; then
        sudo systemctl start amazon-ssm-agent
        sudo systemctl enable amazon-ssm-agent
        sudo systemctl status amazon-ssm-agent

        else
        echo "Versão não suportada."
        fi

        ## Install SSM agent
        #sudo snap install amazon-ssm-agent --classic

        ## Start and enable SSM agent
        #sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
        #sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
        #sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service
        ;;
        "debian")

        ## ------
        ## Debian
        ## ------

        ## Create a new directory and get inside it
        mkdir /tmp/ssm && cd /tmp/ssm

        ## Get the debian package
        wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb

        ## Install SSM agent
        sudo dpkg -i amazon-ssm-agent.deb
        ;;
esac
