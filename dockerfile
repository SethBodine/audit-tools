# Ubuntu Latest
FROM ubuntu 

# Fix for ScoutSuit
RUN ulimit -Sn 1000

#Create a temporary folder to hold the files
WORKDIR /opt/

# Install Python, AWS CLI, GCP, Git, and other tools
RUN apt-get update
RUN apt-get install -y curl gpg lsb-release apt-utils

# Fixing Time and Date NZDT
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata
ENV TZ="Pacific/Auckland"

# RUN ln -fs /usr/share/zoneinfo/Pacific/Auckland /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Add Google and Microsoft Ubuntu Repos
RUN curl -sL https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /etc/apt/trusted.gpg.d/google.gpg > /dev/null
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list
RUN AZ_REPO=$(lsb_release -cs); echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" > /etc/apt/sources.list.d/azure-cli.list

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3 python3-dev python3-pip python3-virtualenv git apt-transport-https ca-certificates gnupg jq gnupg sudo make
# longer install times - not neede for testing
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends awscli google-cloud-cli # azure-cli

# alt approach to azure-cli
RUN apt-get install -y libsodium-dev
RUN SODIUM_INSTALL=system pip install pynacl; pip install azure-cli

# Install additional tools
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nmap vim perl openssl libssl-dev dnsutils curl wget 

# create docker user
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change to non-root privilege
USER docker

# Deploy tools from Github
WORKDIR /opt/
RUN sudo git clone https://github.com/nccgroup/ScoutSuite.git
RUN sudo git clone https://github.com/turbot/steampipe-mod-aws-insights
RUN sudo git clone https://github.com/turbot/steampipe-mod-aws-thrifty
RUN sudo git clone https://github.com/turbot/steampipe-mod-aws-compliance
RUN sudo git clone https://github.com/turbot/steampipe-mod-azure-compliance
RUN sudo git clone https://github.com/turbot/steampipe-mod-azure-thrifty
RUN sudo git clone https://github.com/turbot/steampipe-mod-azure-insights
RUN sudo git clone https://github.com/turbot/steampipe-mod-gcp-compliance
RUN sudo git clone https://github.com/turbot/steampipe-mod-gcp-insights
RUN sudo git clone https://github.com/turbot/steampipe-mod-gcp-thrifty
RUN sudo git clone https://github.com/turbot/steampipe-mod-kubernetes-compliance
RUN sudo git clone https://github.com/turbot/steampipe-mod-kubernetes-insights
RUN sudo git clone https://github.com/turbot/steampipe-mod-net-insights

# New Tools added
RUN sudo git clone https://github.com/bassammaged/awsEnum
RUN sudo git clone https://github.com/JohannesEbke/aws_list_all
RUN sudo git clone https://github.com/securisec/cliam
RUN sudo git clone https://github.com/udhos/update-golang

# Build ScoutSuite Environment
WORKDIR /opt/ScoutSuite/
RUN sudo virtualenv -p python3 venv 
RUN sudo venv/bin/pip install --upgrade pip
RUN sudo venv/bin/pip install -r requirements.txt

# Build Steampipe
RUN sudo /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/turbot/steampipe/main/install.sh)"
RUN steampipe plugin install aws
RUN steampipe plugin install awscfn
RUN steampipe plugin install azure
RUN steampipe plugin install azuread
RUN steampipe plugin install gcp
RUN steampipe plugin install googledirectory
RUN steampipe plugin install googleworkspace
RUN steampipe plugin install net
RUN steampipe plugin install kubernetes

# Build awsEnum
WORKDIR /opt/awsEnum
RUN sudo virtualenv -p python3 venv
RUN sudo venv/bin/pip install --upgrade pip
RUN sudo venv/bin/pip install -r requirements.txt

# Build claim
WORKDIR /opt/update-golang

#RUN if [[ $(wget -qO- https://raw.githubusercontent.com/udhos/update-golang/master/update-golang.sh.sha256 | sha256sum -c) ]]; then sudo ./update-golang.sh; fi
RUN sudo ./update-golang.sh
WORKDIR /opt/claim/cli
# RUN sudo source  /etc/profile.d/golang_path.sh && make dev
#RUN sudo . /etc/profile.d/golang_path.sh && make dev
# RUN sudo bash -c ". /etc/profile.d/golang_path.sh && make dev"

# Drop loader for ScoutSuite and updater script
WORKDIR /opt/ScoutSuite/
COPY ./scoutsuite.sh .
WORKDIR /opt/awsEnum
COPY ./awsEnum.sh .
WORKDIR /sbin/
COPY ./updatetools .

# Create Mapped path
WORKDIR /output/

# updatetools will run every start - will update all installed tools
WORKDIR /opt/
RUN sudo chown docker:docker -R /opt/*
ENTRYPOINT ["/sbin/updatetools"]
