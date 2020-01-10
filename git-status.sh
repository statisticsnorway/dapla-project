#!/usr/bin/env bash

declare -a repos=(
  "dapla-catalog"
  "dapla-catalog-protobuf"
  "dapla-dlp-pseudo-func"
  "dapla-noterepo"
  "dapla-spark"
  "dapla-spark-plugin"
  "dataset-access"
)

printf '\ndapla-project'
echo "----------------------------------------------------------------"
git status --short

for repo in "${repos[@]}"
do
  printf '\n%s' "${repo}"
  echo "----------------------------------------------------------------"
  git -C ${repo} status --short
done