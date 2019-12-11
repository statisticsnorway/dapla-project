#!/usr/bin/env bash

declare -a repos=(
  "dapla-spark-plugin"
  "dapla-noterepo"
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