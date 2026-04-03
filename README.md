# audit-tools

> A containerised security auditing toolkit for multi-cloud environments  bring your credentials, shell in, and start auditing.

[![Build](https://github.com/SethBodine/audit-tools/actions/workflows/publish-dockerfile.yml/badge.svg)](https://github.com/SethBodine/audit-tools/actions/workflows/publish-dockerfile.yml)
[![Last Commit](https://img.shields.io/github/last-commit/SethBodine/audit-tools)](https://github.com/SethBodine/audit-tools/commits/main)
[![Commit Activity](https://img.shields.io/github/commit-activity/m/SethBodine/audit-tools)](https://github.com/SethBodine/audit-tools/commits/main)
[![Open Issues](https://img.shields.io/github/issues/SethBodine/audit-tools)](https://github.com/SethBodine/audit-tools/issues)
[![Stars](https://img.shields.io/github/stars/SethBodine/audit-tools?style=flat)](https://github.com/SethBodine/audit-tools/stargazers)
[![Top Language](https://img.shields.io/github/languages/top/SethBodine/audit-tools)](https://github.com/SethBodine/audit-tools)
[![GHCR](https://img.shields.io/badge/container-ghcr.io-blue?logo=docker)](https://ghcr.io/sethbodine/audit-tools)

---

## What is this?

`audit-tools` is a pre-built container image that bundles open-source cloud security auditing tools into a single, consistent environment. Instead of managing conflicting Python versions, Go binaries, and tool-specific dependencies across different machines, you pull one image and get everything ready to run.

It is aimed at security engineers, cloud architects, and penetration testers who need to assess AWS, Azure, GCP, Oracle Cloud, or Kubernetes environments without standing up complex tooling locally.

**Why containerised?**
- No dependency conflicts between tools
- Consistent behaviour across different operator machines
- Easy to pass around a team  same image, same results
- Mount your local output directory to store findings and evidence

---

## Quick Start

```bash
# Initialise the container image and mount local ~/Documents to /output
tmp_fol=$(mktemp -d)
wget https://raw.githubusercontent.com/SethBodine/audit-tools/main/pm-init.sh -O ${tmp_fol}/pm-init.sh
bash ${tmp_fol}/pm-init.sh
```

Once inside the container, authenticate to your cloud provider of choice and run any of the tools below. See the [wiki](https://github.com/SethBodine/audit-tools/wiki) for detailed usage instructions.

---

## Built-in Wiki (`wiki` CLI)

The container ships with a `wiki` command that lets you browse the documentation without leaving your shell  useful when you're already authenticated and mid-session.

```bash
# example commands
wiki                    # list all pages
wiki --checkov          # jump straight to the checkov page
wiki --search [token]   # search across all pages
wiki --menu             # interactive arrow-key browser
wiki --update           # pull latest wiki from GitHub
```

---

## Output & Saving Results

Most tools write results to stdout or to a file path you specify. Mount a local directory to `/output` at runtime and point tools there:

```bash
# Example  save a Prowler HTML report
prowler aws -M html -o /output
```

---

## Tools

Tools are grouped by purpose. Click the Wiki URL for full usage instructions including authentication steps. The Last Commit badge reflects how actively maintained each upstream tool is.

###  Cloud CLI & Authentication

| Tool | CLI command | Last Commit | Wiki |
| --- | --- | --- | --- |
| AWS CLI | `aws` | ![](https://img.shields.io/github/last-commit/aws/aws-cli) | [Using AWS CLI](https://github.com/SethBodine/audit-tools/wiki/Cloud-Authentication-via-CLI#aws) |
| Azure CLI | `az` | ![](https://img.shields.io/github/last-commit/Azure/azure-cli) | [Using Azure CLI](https://github.com/SethBodine/audit-tools/wiki/Cloud-Authentication-via-CLI#azure) |
| GCP CLI | `gcloud` | | [Using gcloud](https://github.com/SethBodine/audit-tools/wiki/Cloud-Authentication-via-CLI#gcp) |

###  Cloud Security Posture (CSPM)

| Tool | CLI command | Last Commit | Wiki |
| --- | --- | --- | --- |
| Prowler | `. /opt/prowler/prowler.sh && prowler` | ![](https://img.shields.io/github/last-commit/prowler-cloud/prowler) | [Using Prowler](https://github.com/SethBodine/audit-tools/wiki/Using-Prowler) |
| Steampipe | `steampipe` | ![](https://img.shields.io/github/last-commit/turbot/steampipe) | [Using Steampipe](https://github.com/SethBodine/audit-tools/wiki/Using-Steampipe) |
| Powerpipe | `powerpipe` | ![](https://img.shields.io/github/last-commit/turbot/powerpipe) | [Using Powerpipe](https://github.com/SethBodine/audit-tools/wiki/Using-Powerpipe) |
| cazadora | `. /opt/cazadorz/cazadora.sh && python main.py` | ![](https://img.shields.io/github/last-commit/HuskyHacks/cazadora) | [Using cazadorz](https://github.com/SethBodine/docker/wiki/Using-cazadorz) |
| CloudFox | `cloudfox` | ![](https://img.shields.io/github/last-commit/BishopFox/cloudfox) | [Using CloudFox](https://github.com/SethBodine/audit-tools/wiki/Using-cloudfox) |

###  Infrastructure as Code (IaC) Scanning

| Tool | CLI command | Last Commit | Wiki |
| --- | --- | --- | --- |
| checkov | `/opt/semgrep/checkov.sh && checkov` | ![](https://img.shields.io/github/last-commit/bridgecrewio/checkov) | [Using checkov](https://github.com/SethBodine/audit-tools/wiki/Using-checkov) |
| semgrep | `. /opt/semgrep/semgrep.sh && semgrep` | ![](https://img.shields.io/github/last-commit/semgrep/semgrep) | [Using semgrep](https://github.com/SethBodine/audit-tools/wiki/Using-semgrep) |
| poutine | `poutine` | ![](https://img.shields.io/github/last-commit/boostsecurityio/poutine) | [Using poutine](https://github.com/SethBodine/audit-tools/wiki/Using-poutine) |

###  Container & Image Scanning

| Tool | CLI command | Last Commit | Wiki |
| --- | --- | --- | --- |
| trivy | `trivy` | ![](https://img.shields.io/github/last-commit/aquasecurity/trivy) | [Using trivy](https://github.com/SethBodine/audit-tools/wiki/Using-trivy) |
| grype | `grype` | ![](https://img.shields.io/github/last-commit/anchore/grype) | [Using grype](https://github.com/SethBodine/audit-tools/wiki/Using-grype) |
| syft | `syft` | ![](https://img.shields.io/github/last-commit/anchore/syft) | [Using syft](https://github.com/SethBodine/audit-tools/wiki/Using-syft) |
| dockerspy | `dockerspy` | ![](https://img.shields.io/github/last-commit/UndeadSec/DockerSpy) | [Using dockerspy](https://github.com/SethBodine/audit-tools/wiki/Using-dockerspy) |

> Note: This container was not impacted by the recent trivy Feb-2026 compromise.

###  Kubernetes Security

| Tool | CLI command | Last Commit | Wiki |
| --- | --- | --- | --- |
| kubescape | `kubescape` | ![](https://img.shields.io/github/last-commit/kubescape/kubescape) | [Using kubescape](https://github.com/SethBodine/audit-tools/wiki/Using-kubescape) |
| kube-bench | `kube-bench` | ![](https://img.shields.io/github/last-commit/aquasecurity/kube-bench) | [Using kube-bench](https://github.com/SethBodine/audit-tools/wiki/Using-kube-bench) |
| polaris | `polaris` | ![](https://img.shields.io/github/last-commit/FairwindsOps/polaris) | [Using Polaris](https://github.com/SethBodine/audit-tools/wiki/Using-polaris) |

###  Secrets & Credential Scanning

| Tool | CLI command | Last Commit | Wiki |
| --- | --- | --- | --- |
| trufflehog | `trufflehog` | ![](https://img.shields.io/github/last-commit/trufflesecurity/trufflehog) | [Using Trufflehog](https://github.com/SethBodine/audit-tools/wiki/Using-Trufflehog) |
| gitleaks | `gitleaks` | ![](https://img.shields.io/github/last-commit/gitleaks/gitleaks) | [Using Gitleaks](https://github.com/SethBodine/audit-tools/wiki/Using-gitleaks) |

###  Identity & Active Directory

| Tool | CLI command | Last Commit | Wiki |
| --- | --- | --- | --- |
| AzureHound | `AzureHound` | ![](https://img.shields.io/github/last-commit/BloodHoundAD/AzureHound) | [Using AzureHound](https://github.com/SethBodine/audit-tools/wiki/Using-AzureHound) |
| BloodHound | see wiki | ![](https://img.shields.io/github/last-commit/SpecterOps/BloodHound) | [Using BloodHound](https://github.com/SethBodine/audit-tools/wiki/Using-BloodHound-(Legacy-and-CE)) |

###  Utilities & Inventory

| Tool | CLI command | Last Commit | Wiki |
| --- | --- | --- | --- |
| testssl.sh | `/opt/testssl.sh/testssl.sh` | ![](https://img.shields.io/github/last-commit/drwetter/testssl.sh) | [Using testssl.sh](https://github.com/SethBodine/audit-tools/wiki/Using-testssl.sh) |
| fx | `fx` | ![](https://img.shields.io/github/last-commit/antonmedv/fx) | |
| jc | `jc` | ![](https://img.shields.io/github/last-commit/kellyjonbrazil/jc) | |

---

## Recent Changes

### Known Issues
- Prowler does not support Python 3.13 yet  Python 3.12 is deployed specifically for Prowler

### Resolved Issues
- snyk actions are working again  this broke due to a recent GitHub change in how it handles SARIF files
- Build pipelines have been tweaked so the Steampipe issue and Prowler workaround do not break GitHub Actions

### Recently Added
- wiki (including glow and fzf tools) search tool
- cazadora  Search for suspicious M365 OAuth Apps 
- cloudfox  Cloud attack surface enumeration for AWS and Azure
- gitleaks  Fast git-native secrets scanner
- polarisi  Kubernetes workload security and reliability validation

## Pending Changes
### Removal
The following tools will be removed in the next release

| Tool | CLI command | Last Commit | Wiki |
| --- | --- | --- | --- |
| ScoutSuite | `. /opt/ScoutSuite/scoutsuite.sh && scout.py`  stale | ![](https://img.shields.io/github/last-commit/nccgroup/ScoutSuite) | [Using ScoutSuite](https://github.com/SethBodine/audit-tools/wiki/Using-ScoutSuite) |
| aws_list_all | `aws_list_all` | ![](https://img.shields.io/github/last-commit/JohannesEbke/aws_list_all) | [Using aws_list_all](https://github.com/SethBodine/audit-tools/wiki/Using-aws_list_all) |

---

## Contributing

If you want to suggest a new tool or report a broken one, open an issue. PRs welcome  the main Dockerfile is the place to start.

