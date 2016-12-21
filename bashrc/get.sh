#!/bin/bash

cd ~/mattfel1.github.io/bashrc
servers=("max-2" "tucson" "portland" "london" "maxeler")
for s in ${servers[@]}; do
  if [[ $s = "maxeler" ]]; then
    cmd="-P 3033 mfeldman@portal.maxeler.com"
  else
    cmd="${s}.stanford.edu"
  fi
  scp -o ConnectTimeout=1 ${cmd}:~/.bashrc ~/mattfel1.github.io/bashrc/${s}_bashrc.sh
  if [[ $? = 0 ]]; then # success
    sed -i 's/rgb(.*)">$s bashrc/rgb(0,0,255)">$s bashrc/g' index.html
  else # fail
    sed -i 's/rgb(.*)">$s bashrc/rgb(255,0,0)">$s bashrc/g' index.html
  fi
  scp -o ConnectTimeout=1 ${cmd}:~/.bash_aliases ~/mattfel1.github.io/bashrc/${s}_bash_aliases.sh
  if [[ $? = 0 ]]; then # success
    sed -i 's/rgb(.*)">$s bashrc/rgb(0,0,255)">$s bashrc/g' index.html
  else # fail
    sed -i 's/rgb(.*)">$s bashrc/rgb(255,0,0)">$s bashrc/g' index.html
  fi
done

cd ~/mattfel1.github.io/bashrc
git add -A
git commit -m "auto update"
git push

