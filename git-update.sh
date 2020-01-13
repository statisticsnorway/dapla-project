#!/usr/bin/env bash
declare -a repos=(
  "dapla-catalog"
  "dapla-catalog-protobuf"
  "dapla-dlp-pseudo-func"
  "dapla-helidon-testing"
  "dapla-noterepo"
  "dapla-spark"
  "dapla-spark-plugin"
  "dataset-access"
  "dapla-auth-dataset-protobuf"
)

echo git pull --rebase
git pull --rebase

for repo in "${repos[@]}"
do
  if [ -d ${repo} ]; then
    echo git -C ${repo}/ pull --rebase
    git -C ${repo}/ pull --rebase
	else
    echo git clone git@github.com:statisticsnorway/${repo}.git
    git clone git@github.com:statisticsnorway/${repo}.git
  fi
done
