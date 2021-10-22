#!/bin/sh

set -e
set -x

echo "Setting git variables"
export GITHUB_TOKEN=$API_TOKEN_GITHUB
git config --global user.email "devops_enablement@talend.com"
git config --global user.name "devops_enablement"

echo "Cloning destination git repository"
# git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/Talend/talend-cloud-build.git .
git clone https://${GITHUB_TOKEN}@github.com/Talend/talend-cloud-build.git .
git checkout -b "$GITHUB_HEAD_REF"

ssh git@github.com

yq e ".tcdc.infra.aws = $GITHUB_SHA" manifests/main.yml
echo "Adding git commit"
git add .

if git status | grep -q "Changes to be committed"
then
  git commit --message "$GITHUB_HEAD_REF"
  echo "Pushing git commit"
  git push -u origin $GITHUB_HEAD_REF
  echo "Creating a pull request"
  gh pr create -t $GITHUB_HEAD_REF \
               -b "Automotic PR by devops_enablement" \
               -B "master"
else
  echo "No changes detected"
fi
