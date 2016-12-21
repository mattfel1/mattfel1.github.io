#!/bin/bash

servers=("max-2.stanford.edu" "tucson.stanford.edu" "portland.stanford.edu" "london.stanford.edu" "mfeldman@portal.maxeler.com")
for s in ${servers[@]}; do
  echo "scp -o ConnectTimeout=1 ${s}:~/.bashrc ~/mattfel1.github.io/bashrc/${s}_bashrc.sh"
  echo "scp -o ConnectTimeout=1 ${s}:~/.bash_aliases ~/mattfel1.github.io/bashrc/${s}_bash_aliases.sh"
done

cd ~/mattfel1.github.io/bashrc
git add -A
git commit -m "auto update"
git push

