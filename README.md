# Deep-learning

## Scripts
`extract_pdb_info.ipynb`: Extract information about PDB data pulled in the period between 24th of October and 21st of November, see file `pdb_ligand_info.csv`. Clean data to only include PDB files within the criteria described in the "Data Collection" section of the report. The PDB IDs selected for the final dataset is seen in the file `pdb_ids`. 

`calculateRMSDDiffDock.ipynb`: Calculates RMSDs between actual and predicted ligands by DiffDock. Output of script is found in the directory DiffDock_RMSDs. 

`Visualize_RMSDs_DiffDock.R`: Visualizations of DiffDock predictions in regard to evaluating performance. 
