# Ubuntu Latest
FROM ubuntu:rolling

LABEL "audit-tools"="" "org.opencontainers.image.documentation"="https://github.com/SethBodine/docker/wiki" "org.opencontainers.image.title"="audit-tools" "org.opencontainers.image.description"="Docker Container for Cloud Security Audit Tools" "org.opencontainers.image.version"="latest"

# Refactor for less layers

# Fixing Time and Date NZDT, 
ENV TZ="Pacific/Auckland"
# Add Google and Microsoft Ubuntu Repos and add fix for ScoutSuite
# Install Python, AWS CLI, GCP, Git, and other tools, Fixing Time and Date NZDT
RUN bash -c "ulimit -Sn 1000" && mkdir -p /etc/apt/keyrings && \ 
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl gpg lsb-release apt-utils ca-certificates && \
    echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/keyrings/cloud.google.gpg && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata python3 python3-dev \ 
       python3-pip python3-virtualenv git apt-transport-https ca-certificates gnupg jq gnupg sudo make awscli google-cloud-cli \
       libsodium-dev gcc nmap vim perl openssl libssl-dev dnsutils curl wget whois inetutils-ping screen expect-dev dialog less bsdmainutils ssh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
    
# alt approach to azure-cli and deploy other system tools via pip
RUN SODIUM_INSTALL=system pip install --no-cache-dir pynacl; sudo pip install --upgrade pip; sudo pip install --no-cache-dir --break-system-packages azure-cli # aws-list-all

# create docker user
RUN adduser --disabled-password --gecos '' container && adduser container sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change to non-root privilege
USER container

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
    sudo git clone --branch prowler-2 --single-branch https://github.com/prowler-cloud/prowler && \
    sudo git clone https://github.com/trufflesecurity/trufflehog.git && \
    sudo git clone --depth 1 https://github.com/drwetter/testssl.sh.git && \
    sudo git clone https://github.com/udhos/update-golang && \
    sudo git clone https://github.com/Shopify/kubeaudit && \
    sudo git clone https://github.com/BloodHoundAD/AzureHound && \
    sudo mkdir /opt/prowler3 && sudo chown container:container -R /opt/*
    # sudo git clone https://github.com/bassammaged/awsEnum && \
    # sudo git clone https://github.com/securisec/cliam && \

# Build ScoutSuite Environment
WORKDIR /opt/ScoutSuite/
# # temporary workaround - remove scoutsuite venv steps until runtime
# # RUN virtualenv -p python3 venv && venv/bin/pip install --no-cache-dir --upgrade pip && venv/bin/pip install --no-cache-dir -r requirements.txt
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
    steampipe plugin install kubernetes && \
    steampipe plugin install github && \
    steampipe plugin install terraform && \
    steampipe plugin install digitalocean && \
    steampipe plugin install microsoft365 

WORKDIR /opt/steampipe-mod-aws-well-architected
RUN steampipe mod install

WORKDIR /opt/steampipe-mod-aws-top-10
RUN steampipe mod install
    
# Build Prowler Environments
# prowler v2
WORKDIR /opt/prowler
RUN virtualenv -p python3 venv && venv/bin/pip install --no-cache-dir --upgrade pip && venv/bin/pip install --no-cache-dir detect-secrets==1.0.3
# Drop scripts
COPY ./prowler.sh .

# prowler v3
WORKDIR /opt/prowler3
COPY ./prowler3.sh .
RUN virtualenv -p python3 venv && venv/bin/pip install --no-cache-dir --upgrade pip && venv/bin/pip install --no-cache-dir prowler 

# Install tfsec
RUN sudo bash -c "curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash"

# # temporary workaround - remove golang build steps until runtime
# # Update Go-lang
# # WORKDIR /opt/update-golang 
# # RUN sudo ./update-golang.sh

# # Build Kubeaudit
# WORKDIR /opt/kubeaudit
# RUN sudo bash -c ". /etc/profile.d/golang_path.sh && go build -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/kubeaudit ./cmd/ && chmod +x /usr/bin/kubeaudit"

# # Build Trufflehog
# WORKDIR /opt/trufflehog
# RUN sudo bash -c ". /etc/profile.d/golang_path.sh && go build -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/trufflehog"

# # Build AzureHound
# WORKDIR /opt/AzureHound
# RUN sudo bash -c ". /etc/profile.d/golang_path.sh && go build -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/AzureHound"

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
