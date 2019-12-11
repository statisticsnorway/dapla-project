#!/usr/bin/env bash

declare -a repos=(
  "dapla-spark-plugin"
  "dapla-noterepo"
)

for repo in "${repos[@]}"
do
  echo git -C ${repo}/ pull --rebase
  git -C ${repo}/ pull --rebase
done