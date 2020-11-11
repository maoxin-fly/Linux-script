#!/bin/bash
Job_top="/THFS/home/bseei_202/maoxin/Iteration"
filedir="data/data_prepare/Step4"
outputdir="data/Results_Iteration"
CellNum=0
GammaNum=0
node=925
jopbid=2520809
seed=1
jobNum=8
outfile="cout/kind_grid_signal_p_splid_500km_5000bin_Juno"
E_threthold=0
range=500
nbins=5000
grid=0.1
site=4

function gen_job_one () 
{
local script=job_${seed}.sh
local cell_num=${CellNum}
local gamma_num=${GammaNum}

cat << EOF > $script
#!/bin/bash
cd $Job_top
time ./DC4_MDcalibration_thread24.exe -DataSet ${filedir}/Step4_1-${cell_num}_subDataSetA_${gamma_num}_cell_2_2_2.bin -weight ${filedir}/Step4_1-${cell_num}_Initial_Pars_mu_KD_${gamma_num}_Cell_2_2_2.bin -IPD ${filedir}/Step4_1-${cell_num}_sub_Real_IPD_${gamma_num}_cell_2_2_2.bin -Outcost ${outputdir}/Step4_1-${cell_num}_Cost_function_value_${gamma_num}_Cell_2_2_2.bin -Outweight ${outputdir}/Step4_1-${cell_num}_Pars_mu_end_${gamma_num}_Cell_2_2_2.bin
EOF


cat << EOF >> submit_jobs.sh
yhbatch -p BSEEI -w cn[${node}] --jobid=2520849 ./job_${seed}.sh
EOF
}


function gen_job_batch () 
{
	
    if [ -f "submit_jobs.sh" ]; then
        echo "submit_jobs is exist"
        rm submit_jobs.sh
    fi

    for filename in `ls ${Job_top}/${filedir}/Step4_1-*_subDataSetA_*_cell_2_2_2.bin `;
    do
        CellNum1=${filename#*-}
        CellNum=${CellNum1%_sub*}
        GammaNum1=${filename#*SetA_}
        GammaNum=${GammaNum1%_cell*}
        echo $CellNum, $GammaNum
        gen_job_one
        chmod +x ./job_${seed}.sh
        let seed++
     done
}


gen_job_batch
chmod +x submit_jobs.sh
#source /afs/ihep.ac.cn/soft/dayabay/NuWa-64/external/ROOT/5.26.00e_python2.7/x86_64-slc5-gcc41-dbg/root/bin/thisroot.sh
#cd $Job_top
#g++ -g -o crust1_p.exe crust1_p.C `root-config --glibs` `root-config --cflags`


