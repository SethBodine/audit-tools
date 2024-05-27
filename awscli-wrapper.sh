#!/bin/sh

case $(uname -sm) in
	"Linux x86_64") target="awscli-exe-linux-x86_64.zip" ;;
	"Linux aarch64") target="awscli-exe-linux-aarch64.zip" ;;
	*) echo "Error: '$(uname -sm)' is not supported." 1>&2;exit 1 ;;
esac

curl "https://awscli.amazonaws.com/${target}" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
