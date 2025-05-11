#!/usr/bin/env nextflow

//workflow to run the DIA QC files 
// step 1a: convert thermo .raw files to MZML file (thermoRawfileParser of nf-core)
// Step 1b: generate a predicted spectral library from a (reference) proteome file.
// step 2: combine the mzml files an the predicted spectral library to run the diann search.
// Step 3: add the report.stats.tsv file for visualization of the number of identified proteins per file. 

// General parameters are in the nextflow.config file
// run the workflow with: nextflow run main.nf -profile standard, apptainer


// include modules from the different steps in the workflow
include { THERMORAWFILEPARSER } from './modules/nf-core/thermorawfileparser/main'
include { DIANN_PREDICTOR} from './modules/diann_predictor'
include { DIANN_SEARCH} from './modules/diann_search'
include { COMBINE_STATS} from './modules/combine_stats'


//workflow setup
workflow {

    //step 1a: convert thermo .raw files to MZML file (thermoRawfileParser of nf-core)

    input_ch = Channel
    .fromPath("${params.datadir}/QC_list.csv", checkIfExists: true)
    .splitCsv(header: true)
    .map { row ->
        def meta = [ id: row.SampleID ]
        def sample = row.SampleID
        def rawfile = file("${params.datadir}/${row.RawfileName}")
        tuple(meta, sample, rawfile)}

    //Run THERMORAWFILEPARSER module from nf-core
    THERMORAWFILEPARSER(input_ch)


    //step 1b: generate the in silico predicted spectral library 
    input_diann_pred = Channel
        .fromPath("${params.fasta}", checkIfExists:true)
        //.view()

    //Run DIANN_PREDICTOR module
    DIANN_PREDICTOR(input_diann_pred)


    //Step 2: DIA-NN search based on preicted library

    input_diann_search = THERMORAWFILEPARSER.out.spectra
        .combine(DIANN_PREDICTOR.out.pred_lib_out)
        .combine(input_diann_pred)
        //.map { tuple -> [tuple[1], tuple[2], tuple[3]] } 
        .view()
    
    DIANN_SEARCH(input_diann_search)


    //Step 3: downstream visualization
    stats_ch = DIANN_SEARCH.out.diann_outputfile
        .collect()
        .view()
        

    COMBINE_STATS(stats_ch)

}