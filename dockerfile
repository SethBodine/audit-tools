# Ubuntu Latest
#FROM ubuntu 
FROM ubuntu:rolling

LABEL "audit-tools"="" "org.opencontainers.image.documentation"="https://github.com/SethBodine/docker/wiki" "org.opencontainers.image.title"="audit-tools" "org.opencontainers.image.description"="Docker Container for Cloud Security Audit Tools" "org.opencontainers.image.version"="latest"

# Refactor for less layers

# Fixing Time and Date NZDT, 
ENV TZ="Pacific/Auckland"
# Add Google and Microsoft Ubuntu Repos and add fix for ScoutSuite
RUN ulimit -Sn 1000 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl gpg lsb-release apt-utils ca-certificates && \
    curl -sL -o /etc/apt/trusted.gpg.d/google.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list
# Install Python, AWS CLI, GCP, Git, and other tools, Fixing Time and Date NZDT
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata python3 python3-dev python3-pip python3-virtualenv git apt-transport-https ca-certificates gnupg jq gnupg sudo make awscli google-cloud-cli libsodium-dev gcc nmap vim perl openssl libssl-dev dnsutils curl wget whois inetutils-ping screen expect-dev dialog

# alt approach to azure-cli and deploy other system tools via pip
RUN SODIUM_INSTALL=system pip install pynacl; sudo pip install azure-cli aws-list-all

# create docker user
RUN adduser --disabled-password --gecos '' docker && adduser docker sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change to non-root privilege
USER docker

# Deploy tools from Github 
WORKDIR /opt/
RUN sudo git clone https://github.com/nccgroup/ScoutSuite.git && \
    sudo git clone https://github.com/turbot/steampipe-mod-aws-insights && \
    sudo git clone https://github.com/turbot/steampipe-mod-aws-thrifty && \
    sudo git clone https://github.com/turbot/steampipe-mod-aws-compliance && \
    sudo git clone https://github.com/turbot/steampipe-mod-azure-compliance && \
    sudo git clone https://github.com/turbot/steampipe-mod-azure-thrifty && \
    sudo git clone https://github.com/turbot/steampipe-mod-azure-insights && \
    sudo git clone https://github.com/turbot/steampipe-mod-gcp-compliance && \
    sudo git clone https://github.com/turbot/steampipe-mod-gcp-insights && \
    sudo git clone https://github.com/turbot/steampipe-mod-gcp-thrifty && \
    sudo git clone https://github.com/turbot/steampipe-mod-kubernetes-compliance && \
    sudo git clone https://github.com/turbot/steampipe-mod-kubernetes-insights && \
    sudo git clone https://github.com/turbot/steampipe-mod-net-insights && \
    sudo git clone --branch prowler-2 --single-branch https://github.com/prowler-cloud/prowler && \
    sudo git clone https://github.com/Shopify/kubeaudit && \
    sudo git clone https://github.com/bassammaged/awsEnum && \
    sudo git clone https://github.com/securisec/cliam && \
    sudo git clone https://github.com/udhos/update-golang && \
    sudo mkdir /opt/prowler3 && sudo chown docker:docker -R /opt/*

# Build ScoutSuite Environment
WORKDIR /opt/ScoutSuite/
RUN virtualenv -p python3 venv && venv/bin/pip install --upgrade pip && venv/bin/pip install -r requirements.txt
# Drop scripts
COPY ./scoutsuite.sh .

# Build Steampipe
RUN sudo /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/turbot/steampipe/main/install.sh)" && \
    steampipe plugin install aws && \
    steampipe plugin install awscfn && \
    steampipe plugin install azure && \
    steampipe plugin install azuread && \
    steampipe plugin install gcp && \
    steampipe plugin install googledirectory && \
    steampipe plugin install googleworkspace && \
    steampipe plugin install net && \
    steampipe plugin install kubernetes

# Build awsEnum
WORKDIR /opt/awsEnum
RUN virtualenv -p python3 venv && venv/bin/pip install --upgrade pip && venv/bin/pip install -r requirements.txt
# Drop scripts
COPY ./awsEnum.sh .

# Build Prowler Environments
# prowler v2
WORKDIR /opt/prowler
RUN virtualenv -p python3 venv && venv/bin/pip install --upgrade pip && venv/bin/pip install detect-secrets==1.0.3
# Drop scripts
COPY ./prowler.sh .

# prowler v3
WORKDIR /opt/prowler3
RUN virtualenv -p python3 venv && venv/bin/pip install --upgrade pip && venv/bin/pip install prowler-cloud 
# Drop scripts
COPY ./prowler3.sh .

# Build cliam
WORKDIR /opt/update-golang 
RUN sudo ./update-golang.sh
WORKDIR /opt/cliam/cli
# RUN sudo source  /etc/profile.d/golang_path.sh && make dev
RUN bash -c ". /etc/profile.d/golang_path.sh && make dev"

# Build AWS List All
RUN sudo pip install aws-list-all

# Drop scripts
WORKDIR /sbin/
COPY ./updatetools .
WORKDIR /bin/
COPY ./source-this-script.sh .
# COPY ./help .
WORKDIR /home/docker
COPY ./.screenrc .

# Create Mapped path
WORKDIR /output/
WORKDIR /opt/

# updatetools will run every start - will update all installed tools
RUN sudo chown docker:docker -R /opt/*
# Replaced ENTRYPOINT with CMD (will run and start-up can be replaced)
CMD /usr/bin/sleep infinity
