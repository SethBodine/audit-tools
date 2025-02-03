# Ubuntu Latest
FROM ubuntu:rolling

LABEL "audit-tools"="" "org.opencontainers.image.documentation"="https://github.com/SethBodine/docker/wiki" "org.opencontainers.image.title"="audit-tools" "org.opencontainers.image.description"="Docker Container for Cloud Security Audit Tools" "org.opencontainers.image.version"="latest"

# Refactor for less layers

# Fixing Time and Date NZDT, 
ENV TZ="Pacific/Auckland"
# Add Google and Microsoft Ubuntu Repos and add fix for ScoutSuite
# Install Python, GCP, Git, and other tools, Fixing Time and Date NZDT
RUN bash -c "ulimit -Sn 1000" && mkdir -p /etc/apt/keyrings && \ 
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl gpg lsb-release apt-utils ca-certificates && \
    echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/keyrings/cloud.google.gpg && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata python3 python3-dev \ 
       python3-pip python3-virtualenv git apt-transport-https ca-certificates gnupg jq gnupg sudo make google-cloud-cli \
       libsodium-dev gcc nmap vim perl openssl libssl-dev dnsutils curl wget whois inetutils-ping screen expect-dev dialog less bsdmainutils ssh file unzip sipcalc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# push motd
WORKDIR /etc/
COPY ./motd .
COPY ./motd_updates .

# create docker user
RUN adduser --disabled-password --gecos '' container && adduser container sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change to non-root privilege
USER container

# Build awscli v2 
WORKDIR /opt/awscli
COPY ./awscli-wrapper.sh .

# alt approach to azure-cli and deploy other system tools via pip
ENV PIP_ROOT_USER_ACTION=ignore
RUN SODIUM_INSTALL=system sudo pip install --no-cache-dir pynacl; sudo pip install --upgrade pip; sudo pip install --no-cache-dir --break-system-packages azure-cli 

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
    sudo git clone https://github.com/turbot/steampipe-mod-microsoft365-compliance && \
    sudo git clone https://github.com/turbot/steampipe-mod-github-compliance && \
    sudo git clone https://github.com/turbot/steampipe-mod-terraform-aws-compliance && \
    sudo git clone https://github.com/turbot/steampipe-mod-terraform-azure-compliance && \
    sudo git clone https://github.com/turbot/steampipe-mod-terraform-gcp-compliance && \
    sudo git clone https://github.com/turbot/steampipe-mod-aws-perimeter && \
    sudo git clone https://github.com/turbot/steampipe-mod-aws-top-10 && \
    sudo git clone https://github.com/turbot/steampipe-mod-aws-well-architected && \
    sudo git clone https://github.com/turbot/steampipe-mod-github-sherlock && \
    sudo git clone https://github.com/turbot/steampipe-mod-digitalocean-insights.git && \
    sudo git clone https://github.com/turbot/steampipe-mod-snowflake-compliance.git && \
    sudo git clone https://github.com/trufflesecurity/trufflehog.git && \
    sudo git clone --depth 1 https://github.com/drwetter/testssl.sh.git && \
    sudo git clone https://github.com/udhos/update-golang && \
    sudo git clone https://github.com/Shopify/kubeaudit && \
    sudo git clone https://github.com/BloodHoundAD/AzureHound && \
    sudo git clone https://github.com/UndeadSec/DockerSpy.git && \
    sudo chown container:container -R /opt/*

# Build ScoutSuite Environment
WORKDIR /opt/ScoutSuite/
COPY ./scoutsuite.sh .

# Build Steampipe
#RUN sudo /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/turbot/steampipe/main/install.sh)" && \
RUN sudo /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)" && \
    steampipe plugin install aws && \
    steampipe plugin install awscfn && \
    steampipe plugin install azure && \
    steampipe plugin install azuread && \
    steampipe plugin install gcp && \
    steampipe plugin install googledirectory && \
    steampipe plugin install googleworkspace && \
    steampipe plugin install net && \
    steampipe plugin install kubernetes && \
    steampipe plugin install github && \
    steampipe plugin install terraform && \
    steampipe plugin install digitalocean && \
    steampipe plugin install microsoft365 && \
    steampipe plugin install snowflake

WORKDIR /opt/steampipe-mod-aws-well-architected
RUN steampipe mod install

WORKDIR /opt/steampipe-mod-aws-top-10
RUN steampipe mod install

WORKDIR /opt/steampipe-mod-snowflake-compliance
RUN steampipe mod install

# Build Powerpipe
RUN sudo /bin/sh -c "$(curl -fsSL https://powerpipe.io/install/powerpipe.sh)"
WORKDIR /opt/Powerpipe
COPY ./mod.pp .
RUN powerpipe mod update
    
# Build Prowler Environment
WORKDIR /opt/prowler
COPY ./prowler.sh .
RUN virtualenv -p python3 venv && venv/bin/pip install --no-cache-dir --upgrade pip # && venv/bin/pip install --no-cache-dir "prowler"

# Build semgrep
WORKDIR /opt/semgrep
COPY ./semgrep.sh .
RUN virtualenv -p python3 venv && venv/bin/pip install --no-cache-dir --upgrade pip

# Install tfsec
RUN sudo bash -c "curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash"

# Install trivy (tfsec replacement)
RUN sudo bash -c "curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin"

# Install Kubescape
RUN sudo bash -c "curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash"
ENV PATH "$PATH:/home/container/.kubescape/bin"

# Drop scripts
WORKDIR /sbin/
COPY ./updatetools .
WORKDIR /bin/
COPY ./source-this-script.sh .
# COPY ./help .
WORKDIR /home/container
COPY ./.screenrc .

# Create Mapped path
WORKDIR /output/
WORKDIR /opt/

# updatetools will run every start - will update all installed tools
CMD ["/usr/bin/sleep", "infinity"]
