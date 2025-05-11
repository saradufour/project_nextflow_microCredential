process DIANN_PREDICTOR {
    container "biocontainers/diann:1.8.1_cv2"
    label "high"

    input:
    path(fasta)

    output:
    path("lib.predicted.speclib"), emit: pred_lib_out

    script:
    """
    diann --lib "" --qvalue 0.01 --matrices --gen-spec-lib --predictor --fasta ${fasta} --fasta-search  --min-fr-mz 200  --max-fr-mz 1800  --min-pep-len 7  --max-pep-len 30  --min-pr-mz 400  --max-pr-mz 700  --min-pr-charge 1  --max-pr-charge 4  --cut K*,R*  --missed-cleavages 1  --unimod4  --var-mods 1  --var-mod UniMod:35,15.994915,M  --var-mod UniMod:1,42.010565,*n --mass-acc 20  --mass-acc-ms1 10.0  --peptidoforms  --reanalyse  --relaxed-prot-inf --rt-profiling 
    """

    stub:
    """
    
    """
}