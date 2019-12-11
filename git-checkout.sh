#!/usr/bin/env bash

declare -a repos=(
  "dapla-spark-plugin"
  "dapla-noterepo"
)

for repo in "${repos[@]}"
do
  echo git clone git@github.com:statisticsnorway/${repo}.git
  git clone git@github.com:statisticsnorway/${repo}.git
done