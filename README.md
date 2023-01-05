# Deep-learning

## Scripts
`data_preprocess.ipynb`: Split PDB files into separate proteins without ligand information in PDB format and ligand information in SDF format.

`extract_pdb_info.ipynb`: Extract information about PDB data pulled in the period between 24th of October and 21st of November, see file `pdb_ligand_info.csv`. Clean data to only include PDB files within the criteria described in the "Data Collection" section of the report. The PDB IDs selected for the final dataset is seen in the file `pdb_ids.txt`. 

`diffdock_job.sh`: Jobscript to submit diffdock to an HPC environment

`sbdd_job.py`: A script that creates and submits DiffSBDD jobscripts for each PDB file to a HPC environment

`calculateRMSDDiffDock.ipynb`: Calculates RMSDs between actual and predicted ligands by DiffDock. Output of script is found in the directory DiffDock_RMSDs. Input is found in the `Results` directory and should be unzipped for running script. 

`Visualize_RMSDs_DiffDock.R`: Visualizations of DiffDock predictions in regard to evaluating performance. 

## Data
`atoms_count.txt`: number of atoms for each ligand

`binding_pocket.txt`: binding pocket residues for each PDB

`pdb_ids.txt`: contains all PDB IDs

`protein_ligand_csv`: contains file path for protein PDB file and ligand SDF file.

`Results.zip`: Predictions made for both DiffSBDD and DiffDock. 

`DiffDock_RMSDs.zip`: RMSDs between actual and predicted ligans as well as additional information from DiffDock predictions.

``
