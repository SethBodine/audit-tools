# golang is a beast - so we build it then bin it for the container build
FROM golang:latest AS gobuild

# Fixing Time and Date NZDT,
ENV TZ="Pacific/Auckland"

WORKDIR /opt/
RUN git clone https://github.com/BloodHoundAD/AzureHound && \
    git clone https://github.com/trufflesecurity/trufflehog.git && \
    git clone https://github.com/UndeadSec/DockerSpy.git && \
    git clone https://github.com/boostsecurityio/poutine && \
    git clone https://github.com/aquasecurity/kube-bench.git

# this is not ideal - but will group 
RUN bash -c "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build -C /opt/trufflehog -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/trufflehog" && \
    bash -c "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build -C /opt/AzureHound -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/AzureHound" && \
    bash -c "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build -C /opt/DockerSpy -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/dockerspy" && mkdir -p /etc/dockerspy && \
    bash -c "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build -C /opt/poutine -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/poutine" && \
    bash -c "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build -C /opt/kube-bench -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/kube-bench" 

# WORKDIR /opt/trufflehog
# RUN bash -c "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/trufflehog"

# Build AzureHound
# WORKDIR /opt/AzureHound
# RUN bash -c "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/AzureHound"

# Build DockerSpy
# WORKDIR /etc/dockerspy
# WORKDIR /opt/DockerSpy
# RUN bash -c "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/dockerspy"

# Build poutine
# WORKDIR /opt/poutine
# RUN bash -c "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/poutine"

# build kube-bench
# WORKDIR /opt/kube-bench
# RUN bash -c "GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build -v -a -ldflags '-w -s -extldflags "-static"' -o /usr/bin/kube-bench"

#AWS CLI
FROM amazon/aws-cli:latest AS awscli

#Aquasec trivy
FROM aquasec/trivy:latest AS trivy

# disabling this workflow as it blows out the build
# "workaround" for prowler - attempt #3
# Stage 1: Build Python

# FROM debian:bookworm-slim AS python-builder
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     build-essential wget libssl-dev zlib1g-dev \
#     libbz2-dev libreadline-dev libsqlite3-dev curl \
#     libncursesw5-dev xz-utils tk-dev libxml2-dev \
#     libxmlsec1-dev libffi-dev liblzma-dev \
#     && rm -rf /var/lib/apt/lists/*

# WORKDIR /tmp
# RUN wget -q https://www.python.org/ftp/python/3.12.11/Python-3.12.11.tgz \
#     && tar -zxvf Python-3.12.11.tgz \ 
#     && cd Python-3.12.11 \
#     && ./configure --enable-optimizations --with-lto --prefix=/usr/local \
#     && make -j$(nproc) \
#     && make install

# Ubuntu Latest
FROM ubuntu:rolling AS mainbuild

LABEL "audit-tools"="" "org.opencontainers.image.documentation"="https://github.com/SethBodine/docker/wiki" "org.opencontainers.image.title"="audit-tools" "org.opencontainers.image.description"="Docker Container for Cloud Security Audit Tools" "org.opencontainers.image.version"="latest"

# Fixing Time and Date NZDT, 
ENV TZ="Pacific/Auckland"
# Add Google Repos and add fix for ScoutSuite
# Install Python, GCP, Git, and other tools, Fixing Time and Date NZDT
RUN bash -c "ulimit -Sn 1000" && mkdir -p /etc/apt/keyrings && \ 
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl gpg lsb-release apt-utils ca-certificates && \
    echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/keyrings/cloud.google.gpg && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata python3 python3-dev \ 
       python3-pip python3-virtualenv git apt-transport-https ca-certificates gnupg jq gnupg sudo make google-cloud-cli bat fd-find ripgrep du-dust \
       libsodium-dev gcc nmap vim perl openssl libssl-dev dnsutils curl wget whois inetutils-ping screen expect-dev dialog less bsdmainutils ssh file unzip sipcalc groff kubectl libxmlsec1t64 libxslt1.1 pkg-config libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Added pkg-config libffi-dev for prowler fix

# push motd
WORKDIR /etc/
COPY ./motd .
COPY ./motd_updates .

# create docker user
RUN adduser --disabled-password --gecos '' container && adduser container sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change to non-root privilege
USER container

# alt approach to azure-cli and deploy other system tools via pip
ENV PIP_ROOT_USER_ACTION=ignore
RUN SODIUM_INSTALL=system sudo pip install --no-cache-dir pynacl; sudo pip install --upgrade pip; sudo pip install --no-cache-dir --break-system-packages azure-cli aws-list-all

# Deploy tools from Github - removed golang applications - these will be built upstream
WORKDIR /opt/
RUN sudo git clone https://github.com/nccgroup/ScoutSuite.git && \
    sudo git clone --depth 1 https://github.com/drwetter/testssl.sh.git && \
    sudo chown container:container -R /opt/*

# Build ScoutSuite Environment
WORKDIR /opt/ScoutSuite/
COPY ./scoutsuite.sh .

# Build Steampipe 
RUN sudo /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)" 
# && \
#     steampipe plugin install aws && \
#     steampipe plugin install awscfn && \
#     steampipe plugin install azure && \
#     steampipe plugin install azuread && \
#     steampipe plugin install gcp && \
#     steampipe plugin install googledirectory && \
#     steampipe plugin install googleworkspace && \
#     steampipe plugin install net && \
#     steampipe plugin install kubernetes && \
#     steampipe plugin install github && \
#     steampipe plugin install terraform && \
#     steampipe plugin install digitalocean && \
#     steampipe plugin install microsoft365 && \
#     steampipe plugin install snowflake && \
#     steampipe plugin install openai && \
#     steampipe plugin install crtsh && \
#     steampipe plugin install azuredevops && \
#     steampipe plugin install mongodbatlas && \
#     steampipe plugin install okta && \
#     steampipe plugin install alicloud && \
#     steampipe plugin install digitalocean && \
#     steampipe plugin install oci 

# Build Powerpipe
RUN sudo /bin/sh -c "$(curl -fsSL https://powerpipe.io/install/powerpipe.sh)"
WORKDIR /opt/Powerpipe

# pre-work for the mod.pp file includes the following mods

COPY ./mod.pp .
# RUN powerpipe mod update
    
# Prepare Prowler Environment - pre-reqs will be brought down at launch
WORKDIR /opt/prowler
COPY ./prowler.sh .
# disabling this as part of the earlier change
# COPY --from=python-builder /usr/local/bin/python3.12 /usr/local/bin/
# COPY --from=python-builder /usr/local/bin/pip3.12 /usr/local/bin/
# COPY --from=python-builder /usr/local/lib/python3.12 /usr/local/lib/python3.12
# COPY --from=python-builder /usr/local/lib/libpython3.12* /usr/local/lib/

# fix for prowler where support is missing for new python versions 
# https://github.com/SethBodine/audit-tools/issues/44  (blows the image out by 1GB)
# RUN virtualenv -p python3 venv && venv/bin/pip install --no-cache-dir --upgrade pip 
# RUN cd /tmp && sudo wget https://www.python.org/ftp/python/3.12.11/Python-3.12.11.tgz && tar -zxvf Python-3.12.11.tgz && cd Python-3.12.11 && ./configure; \
#     make; sudo make install
# RUN python3.12 -m venv venv && venv/bin/pip install --no-cache-dir --upgrade pip 

# Build semgrep
WORKDIR /opt/semgrep
COPY ./semgrep.sh .
RUN virtualenv -p python3 venv && venv/bin/pip install --no-cache-dir --upgrade pip

# Build checkov
WORKDIR /opt/checkov
COPY ./checkov.sh .
RUN virtualenv -p python3 venv && venv/bin/pip install --no-cache-dir --upgrade pip

# Install trivy (tfsec replacement)
RUN sudo bash -c "curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin"

# Install Kubescape
RUN sudo bash -c "curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash"
ENV PATH="$PATH:/home/container/.kubescape/bin"

# Install grype
RUN sudo bash -c "curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin"

# Install syft
RUN sudo bash -c "curl -sSfL https://get.anchore.io/syft | sudo sh -s -- -b /usr/local/bin"

# Grab compiled bins from golang build
COPY --from=gobuild /usr/bin/trufflehog /usr/bin/trufflehog
COPY --from=gobuild /usr/bin/AzureHound /usr/bin/AzureHound
COPY --from=gobuild /usr/bin/poutine /usr/bin/poutine
COPY --from=gobuild /usr/bin/kube-bench /usr/bin/kube-bench
COPY --from=gobuild /usr/bin/dockerspy /usr/bin/dockerspy
COPY --from=gobuild /opt/DockerSpy/src/ /etc/dockerspy
COPY --from=awscli /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=awscli /usr/local/bin/aws /usr/local/bin/aws
COPY --from=awscli /usr/local/bin/aws_completer /usr/local/bin/aws_completer
ENV PATH="/usr/local/aws-cli/v2/current/bin:$PATH"
COPY --from=trivy /usr/local/bin/trivy /usr/local/bin/trivy

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
