
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

function fastapp {
cp -r ${SPATIAL_HOME}/extern/compiler/src/* ${PUB_HOME}/compiler/src/spatial/compiler;cd ${PUB_HOME}/;sbt -DshowSuppressedErrors=true compile
if [[ "$?" -ne "0" ]]; then
  echo "messed up compile"
else
  bin/spatial ${1}
  if [[ "$?" -ne "0" ]]; then
    echo "messed up spatial build"
  else
    remk
  fi
fi
}

function freeports {
stale_sims=(`ps axh -O user,etimes | grep mattfel | grep maxcompilersim  | awk '{if ($3 >= 0) print $1}'`)
for job in ${stale_sims[@]}; do
        kill -9 $job
done

}


function freesemaphores {
for semid in `ipcs -s | cut -d" " -f 2` ; do pid=`ipcs -s -i $semid | tail -n 2 | head -n 1 | awk '{print $5}'`; running=`ps --no-headers -p $pid | wc -l` ; if [ $running -eq 0 ] ; then ipcrm -s $semid ; fi ; done
}

function storemaxeler {
rsync -avz -e "ssh -p 3033" mfeldman@portal.maxeler.com:/home/mfeldman/$1 /remote/mattfel/
}

function remk {
cd ${PUB_HOME}/out
make clean
ant
# Patch makefile, Because ant won't run inside a makefile if I set the symlinks correctly
sed -i "s/JAVA_HOME = \/usr\/lib\/jvm\/java-7-openjdk-amd64/JAVA_HOME = \/usr/g" Makefile
sed -i "s/ant/#\/usr\/share\/ant\/bin\/ant/g" Makefile
sed -i '4i J_HOME=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.40.x86_64' Makefile
sed -i "s/-I\$(JAVA_HOME)\/include -I\$(JAVA_HOME)\/include\/linux/-I\$(J_HOME)\/include -I\$(J_HOME)\/include\/linux/g" Makefile
make sim | grep --color=never -A4 "\[maxjcompiler\] [0-9]\+\. ERROR\|^[^\[]\|\[maxjcompiler\] [0-9]\+ problems"
}
## Helper for deleting directories when you still have those nfs files stuck in use
# 1 - directory to delete
stubborn_delete() {
  rm -rf $1 > /tmp/todelete 2>&1
  undeletable=(`cat /tmp/todelete | wc -l`)
  if [[ $undeletable -gt 0 ]]; then
    while read p; do
      f=(`echo $p | sed 's/rm: cannot remove \`//g' | sed "s/': Device or resource busy//g"`)
      fuser -k $f
    done </tmp/todelete
  fi
  rm -rf $1
}

inferapp() {
## MODERN WAY
grep -r "TopKernelLib for app" ./maxj

## OLD SCHOOL WAY
#echo "Run this fcn in the base output maxj dir to infer which app this is"
#apps=("DotProduct" "MatMult_inner" "TPCHQ6" "BlackScholes" "MatMult_outer"
#        "Kmeans"  "GEMM"      "GDA"    "SGD"   "LogReg" "OuterProduct"
#        "BFS" "PageRank" "TriangleCounting" "SparseSGD" "TPCHQ1"
#        "Memcpy2D" "SimpleFold" "Niter" "SimpleReduce" "FifoLoadStore" "ParFifoLoad" "FifoLoad" "SimpleTileLoadStore" "DeviceMemcpy" "FifoPushPop" "ChangingCtrMax" "SequentialWrites" "BubbledWriteTest" "MultiplexedWriteTest" "InOutArg" "ScatterGather" "BlockReduce2D" "UnalignedLd" "BlockReduce1D" "SimpleSequential" "CharBramTest"
#"CharStoreTest" "CharLoadTest")
#for a in ${apps[@]}; do
#  cnt=(`grep -r "$a" ./maxj | grep -v "makes BFS work\|for BFS" | wc -l`)
#  if [ $cnt -gt 0 ]; then
#    echo "$a has $cnt"
#  fi
#done
}



alias ll='ls -al'
alias freeports='pkill -f lib/maxeleros-sim/daemon/maxelerosd'
alias cpudense='cp ~/cpucodedense.c ~/maxj/CPUCode/cpucode.c'
alias cpusparse='cp ~/cpucodesparse.c ~/maxj/CPUCode/cpucode.c'
alias check='bash ~/maxj/run.sh 96 96;sed -i "s/ /\n/g" /kunle/users/mattfel/maxj/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj/CPUCode/outfile_offchip_result* ~/maxj/dataO ~/maxj/dataM'
alias rawcheck1='sed -i "s/ /\n/g" /kunle/users/mattfel/maxj1/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj1/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias rawcheck2='sed -i "s/ /\n/g" /kunle/users/mattfel/maxj2/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj2/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias rawcheck3='sed -i "s/ /\n/g" /kunle/users/mattfel/maxj3/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj3/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias rawcheck4='sed -i "s/ /\n/g" /kunle/users/mattfel/maxj4/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj4/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias rawcheck5='sed -i "s/ /\n/g" /kunle/users/mattfel/maxj5/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj5/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias rawcheck6='sed -i "s/ /\n/g" /kunle/users/mattfel/maxj6/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj6/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias getcycles='find . -name "debug_printf.txt" -exec cat {} + | grep cycles'
alias copymax='ssh -p 3033 mfeldman@portal.maxeler.com rm -rf /home/mfeldman/maxj;scp -P 3033 -r ~/maxj mfeldman@portal.maxeler.com:/home/mfeldman/'
alias usage='cat RunRules/DFE/Top_cmd.log | grep %'
alias mk2014='export MAXELEROSDIR=/opt/maxeler/maxcompiler-2014.1/lib/maxeleros-sim;export MAXCOMPILERDIR=/opt/maxeler/maxcompiler-2014.1/;export PATH=$PATH:/opt/maxeler/maxcompiler-2014.1/bin;make clean sim;. ~/.bashrc;echo "Remember you need the 2014 vars when you run.sh too"'
export LM_LICENSE_FILE=7195@cadlic0.stanford.edu:$LM_LICENSE_FILE
export PATH=$PATH:/opt/altera/13.1/quartus/bin/
export MAXELEROSDIR=/opt/maxcompiler2016/lib/maxeleros-sim;export MAXCOMPILERDIR=/opt/maxcompiler2016;export PATH=$PATH:/opt/maxcompiler2016/bin
#export MAXELEROSDIR=/opt/maxeler/maxcompiler-2014.1/lib/maxeleros-sim;export MAXCOMPILERDIR=/opt/maxeler/maxcompiler-2014.1/;export PATH=$PATH:/opt/maxeler/maxcompiler-2014.1/bin
#export MAXELEROSDIR=/opt/maxcompiler_oldlib/lib/maxeleros-sim;export MAXCOMPILERDIR=/opt/maxcompiler_oldlib;export PATH=$PATH:/opt/maxcompiler_oldlib/bin
export HYPER_HOME=${HOME}/hyperdsl
export SPATIAL_HOME=${HYPER_HOME}/spatial
export PUB_HOME=${SPATIAL_HOME}/published/Spatial
export FORGE_HOME=${HYPER_HOME}/forge
export DELITE_HOME=${HYPER_HOME}/delite
export LMS_HOME=${HYPER_HOME}/virtualization-lms-core
export PIR_HOME=${HYPER_HOME}/spatial/published/Spatial
export JAVA_HOME=/usr/
