# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

function bumpheap(){
for i in {$1..$2}; do
  echo -n "BEFORE:"
  cmd="cat maxj${i}/cpp/src/static/cpp/DeliteMemory.cpp | grep \"define DEFAULT_BLOCK_SIZE\""
  eval "$cmd"
  cmd="sed -i \"s/\#define DEFAULT_BLOCK_SIZE 1UL\*1024\*1024$/#define DEFAULT_BLOCK_SIZE 1UL*1024*1024*8/g\" ./maxj${i}/cpp/src/static/cpp/DeliteMemory.cpp"
  eval "$cmd"
  echo -n "AFTER:"
  cmd="cat maxj${i}/cpp/src/static/cpp/DeliteMemory.cpp | grep \"define DEFAULT_BLOCK_SIZE\""
  eval "$cmd"
done
}


function inferapp {
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




function use2() {
export MAXELEROSDIR=/opt/maxeler/maxcompiler-2014.2/maxeleros
export LM_LICENSE_FILE=/opt/maxeler/licenses/1-DKYEN7_License.dat
export LD_PRELOAD=/opt/maxeler/maxcompiler-2014.2/maxeleros/lib/libmaxeleros.so

}

# User specific aliases and functions
export MAXELEROSDIR=/opt/maxeler/maxeleros
export LM_LICENSE_FILE=/opt/maxeler/licenses/1-DKYEN7_License.dat
export PATH=$PATH:/opt/altera/13.1/quartus/bin/
export LD_PRELOAD=/opt/maxeler/maxeleros/lib/libmaxeleros.so
alias run='cd /home/mfeldman/ASPLOS16;bash -i run.sh'
alias patchver='sed -i "s/#define MAXFILE_MAXCOMPILER_VERSION_NUM          1/#define MAXFILE_MAXCOMPILER_VERSION_NUM          2/g" ./Top_MAX4848A_DFE/results/Top.max;/opt/maxeler/maxcompiler-2014.2/bin/sliccompile Top_MAX4848A_DFE/results/Top.max maxobj_Top_DFE.o'
alias remake1='cd ~/maxj1;make fpga'
alias remake2='cd ~/maxj2;make fpga'
alias remake3='cd ~/maxj3;make fpga'
alias remake4='cd ~/maxj4;make fpga'
alias remake5='cd ~/maxj5;make fpga'
alias remake6='cd ~/maxj6;make fpga'
alias remake7='cd ~/maxj7;make fpga'
alias remake8='cd ~/maxj8;make fpga'
alias remake9='cd ~/maxj9;make fpga'
alias makepow='quartus_pow Top_MAX4848A_DFE/scratch/altera_quartus/asm/altera_quartus/MAX4MAIAPeripheryTop --default_input_io_toggle_rate=12.5% --default_toggle_rate=12.5%'
alias getpow='cat Top_MAX4848A_DFE/scratch/altera_quartus/asm/altera_quartus/MAX4MAIAPeripheryTop.pow.summary | grep "Dissipation" | sed "s/^.* : //g" | sed "s/ .*//g";# | tr  "\n" ,'
alias strip_comments='sed -i "s/^\/\*.*\*\/$//g" maxj/src/kernels/TopKernelLib.maxj;sed -i "s/\/\/.*$//g" maxj/src/kernels/TopKernelLib.maxj'
alias patch='sed -i "s/\/kunle\/users\/mattfel/\/home\/mfeldman/g" ./CPUCode/cpucode.c;sed -i "s/~\//\/home\/mfeldman\//g" ./CPUCode/cpucode.c'
alias rawcheck1='sed -i "s/ /\n/g" /home/mfeldman/maxj1/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj1/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias rawcheck2='sed -i "s/ /\n/g" /home/mfeldman/maxj2/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj2/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias rawcheck3='sed -i "s/ /\n/g" /home/mfeldman/maxj3/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj3/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias rawcheck4='sed -i "s/ /\n/g" /home/mfeldman/maxj4/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj4/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias rawcheck5='sed -i "s/ /\n/g" /home/mfeldman/maxj5/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj5/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias rawcheck6='sed -i "s/ /\n/g" /home/mfeldman/maxj6/CPUCode/outfile_*;echo "MAXJ                    SCALA                   ORIGINAL MODEL";pr -m -t ~/maxj6/CPUCode/outfile_offchip_result* ~/dataO ~/dataM'
alias checkutil='cat RunRules/DFE/maxfiles/Top_MAIA_DFE/_build.log | grep "Logic util\|Block memory"'
alias comment_prints='cd cpp;files=(`grep -rl "^std::cout << x" .`);for f in ${files[@]}; do sed -i "s/std::cout << x/\/\/std::cout/g" $f; done;cd ../'
alias getusage='cat Top_MAX4848A_DFE/_build.log | grep %'
alias freeports='ps -u mfeldman | egrep -v "ssh|screen|bash"| awk '"'"'{print $1}'"'"' | xargs -t kill'
export QUARTUS_64BIT=1
