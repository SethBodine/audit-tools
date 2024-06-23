#!/bin/sh /usr/bin/source-this-script.sh
# Prep Environment

SCRIPT_PATH="/opt/semgrep/"
APP_NAME="Semgrep"

#[[ ${VIRTUAL_ENV} ]] && deactivate
if [ -n "${VIRTUAL_ENV+x}" ]; then deactivate; fi


cd ${SCRIPT_PATH}  || exit #handle for cd failure
. venv/bin/activate
pip install --upgrade pip
pip install --upgrade semgrep
pip install --upgrade semgrep-rules-manager

[[ ! -f "custom-rules" ]] && mkdir "custom-rules"

semgrep-rules-manager --dir custom-rules download

rm custom-rules/community/.pre-commit-config.yaml
rm custom-rules/gitlab/.gitlab-ci.yml
rm custom-rules/elttam/.pre-commit-config.yaml
rm custom-rules/community/.github/stale.yml
rm custom-rules/community/.github/workflows/*
rm custom-rules/gitlab/ci/schema_gitlab.yml
rm custom-rules/gitlab/ci/schema_semgrep.yml
rm custom-rules/gitlab/qa/expect/deploy/with-test-rules/lgpl-cc/phpcs_security_audit.yml
rm custom-rules/gitlab/qa/fixtures/deploy/default/mappings/bandit.yml
rm custom-rules/gitlab/qa/fixtures/deploy/default/mappings/brakeman.yml
rm custom-rules/gitlab/qa/fixtures/deploy/default/mappings/gitlab_ee_java.yml
rm custom-rules/gitlab/qa/fixtures/deploy/default/mappings/gitlab_lgpl_cc_java.yml
rm custom-rules/gitlab/qa/fixtures/deploy/default/mappings/mobsf.yml
rm custom-rules/gitlab/qa/fixtures/deploy/default/mappings/nodejs_scan.yml
rm custom-rules/gitlab/qa/fixtures/deploy/default/mappings/phpcs_security_audit.yml
rm custom-rules/gitlab/qa/fixtures/deploy/default/rules/lgpl-cc/php/assert/rule-assert-use.yml
rm custom-rules/trailofbits/.github/workflows/semgrep-rules-format.yml
rm custom-rules/trailofbits/.github/workflows/*
rm custom-rules/elttam/.github/*
rm -rf custom-rules/elttam/.github/*

printf "\n\n%s Environment Ready... execute \"deactivate\" to exit the environment\n\n" "${APP_NAME}"
