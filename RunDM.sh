#PBS –N DM
#PBS -l nodes=1:ppn=1

cd $PBS_O_WORKDIR

/usr/local/MATLAB/R2022a/bin/matlab -nodisplay -nodesktop Configurations.m output.txt