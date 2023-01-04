#!/usr/bin/env python3

import sys
import time
import os
import subprocess

### Write username
# usr = "mansto"

## Part 2: Only Administrator
def Administrator():
    try:
        if len(sys.argv) > 3:
            pdb_ids = open(sys.argv[1], "r")
            pockets = open(sys.argv[2], "r")
            ligand_sizes = open(sys.argv[3], "r")
        else:
            print("Missing input arguments: Expected pdb and pocket file")
    except IOError as err:
        print("Could not read file(s): ", str(err))

    # Run through file
    jobList = [] # Save job IDs for the collector

    pdb = pdb_ids.readline()[:-1]
    pocket = pockets.readline()[:-1]
    ligand_size = ligand_sizes.readline()[:-1]

    while (pdb != "") & (pocket != ""):
        # Create output dir
        subprocess.run(["mkdir", "results/"+pdb])

        # Get pocket
        pocket = pocket.split("\t")[1]

        # Define command
        command = "python3 DiffSBDD/generate_ligands.py DiffSBDD/checkpoints/full_atom.ckpt --pdbfile ~/pdb/" + pdb + ".pdb --outdir results/" + pdb + " --resi_list " + pocket + " --n_samples 10 --num_nodes_lig " + ligand_size

        jobid = submit2(command, directory='',
                        runtime=15, cores=1, ram=4,
                        gpu = True, name = "SBDD-" + pdb)
        jobList.append(jobid) # Save job ID

        pdb = pdb_ids.readline()[:-1]
        pocket = pockets.readline()[:-1]
        ligand_size = ligand_sizes.readline()[:-1]

        time.sleep(1)

#### SUBMIT function ####
def submit2(command, runtime, cores, ram, directory='',
    output='/dev/null', error='/dev/null', gpu = False, name = "JOB"):
    """
    Function to submit a job to the Queueing System - without jobscript file
    Parameters are:
    command:   The command/program you want executed together with any parameters.
               Must use full path unless the directory is given and program is there.
    directory: Working directory - where should your program run, place of your data.
               If not specified, uses current directory.
    modules:   String of space separated modules needed for the run.
    runtime:   Time in minutes set aside for execution of the job.
    cores:     How many cores are used for the job.
    ram:       How much memory in GB is used for the job.
    group:     Accounting - which group pays for the compute.
    output:    Output file of your job.
    error:     Error file of your job.
    """
    runtime = int(runtime)
    cores = int(cores)
    ram = int(ram)
    if cores > 10:
        print("Can't use more than 10 cores on a node")
        sys.exit(1)
    if ram > 120:
        print("Can't use more than 120 GB on a node")
        sys.exit(1)
    if runtime < 1:
        print("Must allocate at least 1 minute runtime")
        sys.exit(1)
    minutes = runtime % 60
    hours = int(runtime/60)
    walltime = "{:d}:{:02d}:00".format(hours, minutes)
    if directory == '':
        directory = os.getcwd()
    # Making a jobscript
    script = '#!/bin/sh\n'
    script += '#BSUB -q gpuv100\n'
    script += '#BSUB -J ' + name + '\n'
    if gpu == True:
        script += '#BSUB -gpu "num=1:mode=exclusive_process"\n'
    script += '#BSUB -R "rusage[mem={}GB]"\n'.format(ram)
    script += '#BSUB -M {}GB\n'.format(ram)
    script += '#BSUB -W {}:{}\n'.format(hours, minutes)
    script += '#BSUB -u mansto@dtu.dk\n'
    script += '#BSUB -B\n'
    script += '#BSUB -N\n'
    script += '#BSUB -o ' + output + '\n'
    script += '#BSUB -e ' + error + '\n'

    ## INIT conda
    script += '__conda_setup="$(' + "'/zhome/04/6/137648/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)" + '"\n'
    script += 'if [ $? -eq 0 ]; then\n'
    script += '\teval "$__conda_setup"\n'
    script += 'else\n'
    script += '\tif [ -f "/zhome/04/6/137648/miniconda3/etc/profile.d/conda.sh" ]; then\n'
    script += '\t\t. "/zhome/04/6/137648/miniconda3/etc/profile.d/conda.sh"\n'
    script += '\telse\n'
    script += '\t\texport PATH="/zhome/04/6/137648/miniconda3/bin:$PATH"\n'
    script += '\tfi\n'
    script += 'fi\n'
    script += 'unset __conda_setup\n'

    # Activate environment
    script += 'conda activate sbdd-env\n'

    # Run command
    script += command + '\n'
    # The submit
    job = subprocess.run(['bsub'], input=script, stdout=subprocess.PIPE, universal_newlines=True)
    jobid = job.stdout.split('.')[0]
    return jobid


Administrator()
