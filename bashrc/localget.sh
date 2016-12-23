#!/bin/bash

cd ~/mattfel1.github.io/bashrc
git pull
cp ~/.bashrc ~/mattfel1.github.io/bashrc/local_bashrc.txt
if [[ $? = 0 ]]; then # success
  st="sed -i 's/rgb(.*)\"><font color=\"rgb(.*)\">.*local bashrc/rgb(5,140,5)\"><font color=\"rgb(5,140,5)\">✓ local bashrc/g' index.html"
  eval $st
else # fail
  st="sed -i 's/rgb(.*)\"><font color=\"rgb(.*)\">.*local bashrc/rgb(255,51,51)\"><font color=\"rgb(255,51,51)\">× local bashrc/g' index.html"
  eval $st
fi
cp ~/.bash_aliases ~/mattfel1.github.io/bashrc/local_bash_aliases.txt
if [[ $? = 0 ]]; then # success
  st="sed -i 's/rgb(.*)\"><font color=\"rgb(.*)\">.*local bash_alias/rgb(5,140,5)\"><font color=\"rgb(5,140,5)\">✓ local bash_alias/g' index.html"
  eval $st
else # fail
  st="sed -i 's/rgb(.*)\"><font color=\"rgb(.*)\">.*local bash_alias/rgb(255,51,51)\"><font color=\"rgb(255,51,51)\">× local bash_alias/g' index.html"
  eval $st
fi

cd ~/mattfel1.github.io/bashrc
git add -A
git commit -m "auto update from local"
git push

