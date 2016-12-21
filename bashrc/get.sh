#!/bin/bash

servers=("max-2" "tucson" "portland" "london")
for s in ${servers[@]}; do
  scp -o ConnectTimeout=1 ${s}.stanford.edu:~/.bashrc ~/mattfel1.github.io/bashrc/${s}_bashrc.sh
  scp -o ConnectTimeout=1 ${s}.stanford.edu:~/.bash_aliases ~/mattfel1.github.io/bashrc/${s}_bash_aliases.sh
done


