#!/bin/bash

cd ~/mattfel1.github.io/bashrc
servers=("max-2" "tucson" "portland" "london" "maxeler")
for s in ${servers[@]}; do
  if [[ $s = "maxeler" ]]; then
    cmd="-P 3033 mfeldman@portal.maxeler.com"
  else
    cmd="${s}.stanford.edu"
  fi
  scp -o ConnectTimeout=1 ${cmd}:~/.bashrc ~/mattfel1.github.io/bashrc/${s}_bashrc.txt
  if [[ $? = 0 ]]; then # success
    st="sed -i 's/rgb(.*)\"><font color=\"rgb(.*)\">.*${s} bashrc/rgb(0,140,0)\"><font color=\"rgb(0,140,0)\">✓ ${s} bashrc/g' index.html"
    eval $st
  else # fail
    st="sed -i 's/rgb(.*)\"><font color=\"rgb(.*)\">.*${s} bashrc/rgb(255,0,0)\"><font color=\"rgb(255,0,0)\">× ${s} bashrc/g' index.html"
    eval $st
  fi
  scp -o ConnectTimeout=1 ${cmd}:~/.bash_aliases ~/mattfel1.github.io/bashrc/${s}_bash_aliases.txt
  if [[ $? = 0 ]]; then # success
    st="sed -i 's/rgb(.*)\"><font color=\"rgb(.*)\">.*${s} bash_alias/rgb(0,140,0)\"><font color=\"rgb(0,140,0)\">✓ ${s} bash_alias/g' index.html"
    eval $st
  else # fail
    st="sed -i 's/rgb(.*)\"><font color=\"rgb(.*)\">.*${s} bash_alias/rgb(255,0,0)\"><font color=\"rgb(255,0,0)\">× ${s} bash_alias/g' index.html"
    eval $st
  fi
done

cd ~/mattfel1.github.io/bashrc
git add -A
git commit -m "auto update"
git push

