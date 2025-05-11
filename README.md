# Nextflow project micro credential 

## DIAQC pipeline 
In the VIB Proteomics core, at least 2 DIAQC's hould be run on the LC-MS/MS equipment. An automated workflow is the most reproducible way to process the data. 

## set up
- step 1a: convert thermo .raw files to MZML file (thermoRawfileParser of nf-core)
- Step 1b: generate a predicted spectral library from a (reference) proteome file.
- step 2: combine the mzml files an the predicted spectral library to run the diann search.
- Step 3: add the report.stats.tsv file for visualization of the number of identified proteins per file. 


## Instructions

This pipeline was set up on the Gent cluster of the VSC.
Make sure the Nexflow module is loaded and the environment variables are set. 

```
module load Nextflow/24.04.2
export APPTAINER_CACHEDIR=${VSC_SCRATCH}/.apptainer_cache
export APPTAINER_TMPDIR=${VSC_SCRATCH}/.apptainer_tmp
```

note: the pipeline was tested on the donphan(interactive/debug) cluster using 1 node and 4 cores. Using 2 nodes and 8 cores would be beneficial for the runtime. It took 1h12min to run the example dataset. the example dataset can be downloaded [here](https://cloud.cmb.ugent.be/index.php/s/i699Sa7FmQe4gzt).

**Save the .raw files in the 'pipeline/data' folder and fill in the QC_list.csv file**


Different profiles are configured, they can be checked in the 'pipeline/nextflow.config' file.
an example setup: 

```
nextflow run main.nf -profile standard,apptainer
```


### Modules
1. THERMORAWFILEPARSER
module available on nf-core
Thermo raw files can not be processsed on a LINUX system. The thermorawfileparser converts thermo raw files in MZML format. 


2. DIANN PREDICTOR
uses a docker image from DIA-NN v1.8.1
creates a predicted spectral library from a FASTA input
output file: lib.predicted.speclib

3. DIANN SEARCH
uses a docker image from DIA-NN v1.8.1
the MZML raw data is searched with DIA-NN against the predicted spectral library

4. COMBINE STATS
Custom R script (located in the bin folder) that uses the report.stats.tsv output file from the DIA-NN search. 


### future improvements
- DIA-NN predictor and search could be combined in 1 workflow and splitting up in subworkflows. 
- When a predicted library is already created for a certain organism, step 1b could be skipped to safe time. 
- The R script could be adapted to visualize other results/statistics.
