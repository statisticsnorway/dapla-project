#!/usr/bin/env bash

echo git pull --rebase
git pull --rebase

while read -r repo
do
  if [ -d ${repo} ]; then
    echo git -C ${repo}/ pull --rebase
    git -C ${repo}/ pull --rebase
  else
    echo git clone git@github.com:statisticsnorway/${repo}.git
    git clone git@github.com:statisticsnorway/${repo}.git
  fi

done < repos.txt


