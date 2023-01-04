#!/bin/sh
#BSUB -q gpuv100
#BSUB -J DiffDock
#BSUB -gpu "num=1:mode=exclusive_process"
#BSUB -R "rusage[mem=25GB]"
#BSUB -M 25GB
#BSUB -W 24:00
#BSUB -u mansto@dtu.dk
#BSUB -B
#BSUB -N
#BSUB -o ../DiffDock.log
#BSUB -e ../DiffDock.err

__conda_setup="$('/zhome/04/6/137648/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
        eval "$__conda_setup"
else
        if [ -f "/zhome/04/6/137648/miniconda3/etc/profile.d/conda.sh" ]; then
                . "/zhome/04/6/137648/miniconda3/etc/profile.d/conda.sh"
        else
                export PATH="/zhome/04/6/137648/miniconda3/bin:$PATH"
        fi
fi
unset __conda_setup
conda activate DiffDock-env

python3 inference.py --protein_ligand_csv ../../dat/protein_ligand.csv --out_dir ../results --inference_steps 20 --samples_per_complex 10 --batch_size 10 --actual_steps 18 --no_final_step_noise
