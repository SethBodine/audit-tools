# Ubuntu Latest
FROM ubuntu 

#Create a temporary folder to hold the files
WORKDIR /opt/

# Install Python, AWS CLI, GCP, Git, and other tools
RUN apt-get update
RUN apt-get install -y curl gpg lsb-release apt-utils
RUN DEBIAN_FRONTEND=noninteractive TZ=Pacific/Auckland apt-get -y install tzdata

# Add Google and Microsoft Ubuntu Repos
RUN curl -sL https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /etc/apt/trusted.gpg.d/google.gpg > /dev/null
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list
RUN AZ_REPO=$(lsb_release -cs); echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" > /etc/apt/sources.list.d/azure-cli.list

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3 python3-dev python3-pip python3-virtualenv git apt-transport-https ca-certificates gnupg jq gnupg sudo
# longer install times - not neede for testing
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends awscli google-cloud-cli azure-cli
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
RUN sudo git clone https://github.com/turbot/steampipe-mod-azure-compliance
RUN sudo git clone https://github.com/turbot/steampipe-mod-azure-thrifty
RUN sudo git clone https://github.com/turbot/steampipe-mod-azure-insights
RUN sudo git clone https://github.com/turbot/steampipe-mod-gcp-compliance
RUN sudo git clone https://github.com/turbot/steampipe-mod-gcp-insights
RUN sudo git clone https://github.com/turbot/steampipe-mod-gcp-thrifty
RUN sudo git clone https://github.com/turbot/steampipe-mod-kubernetes-compliance
RUN sudo git clone https://github.com/turbot/steampipe-mod-kubernetes-insights
RUN sudo git clone https://github.com/turbot/steampipe-mod-net-insights

# Build ScoutSuite Environment
WORKDIR /opt/ScoutSuite/
RUN sudo virtualenv -p python3 venv 
RUN sudo venv/bin/pip install --upgrade pip
RUN sudo venv/bin/pip install -r requirements.txt

# Build Steampipe
RUN sudo /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/turbot/steampipe/main/install.sh)"
RUN steampipe plugin install aws
RUN steampipe plugin install azure
RUN steampipe plugin install azuread
RUN steampipe plugin install gcp
RUN steampipe plugin install googledirectory
RUN steampipe plugin install googleworkspace
RUN steampipe plugin install net
RUN steampipe plugin install kubernetes

# Drop loader for ScoutSuite and updater script
WORKDIR /opt/ScoutSuite/
COPY ./scoutsuite.sh .
WORKDIR /sbin/
COPY ./updatetools .

# Create Mapped path
WORKDIR /output/

# updatetools will run every start - will update all installed tools
WORKDIR /opt/
ENTRYPOINT ["/sbin/updatetools"]
