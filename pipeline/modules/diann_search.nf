process DIANN_SEARCH {
    container "biocontainers/diann:1.8.1_cv2"
    publishDir ("${params.outdir}/diann-output/${sample}/", mode: 'symlink')
    label "high"

    input:
    tuple val(sample), path(mzml), path(library), path(fasta)

    output:
    path("${sample}-report.stats.tsv"), emit: diann_outputfile

    script:
    """
    diann --f ${mzml} --lib ${library} --out ${sample}-report.tsv --qvalue 0.01 --matrices --gen-spec-lib --fasta ${fasta} --reanotate --min-fr-mz 200  --max-fr-mz 1800  --min-pep-len 7  --max-pep-len 30  --min-pr-mz 400  --max-pr-mz 700  --min-pr-charge 1  --max-pr-charge 4  --cut K*,R*  --missed-cleavages 1  --unimod4  --var-mods 1  --var-mod UniMod:35,15.994915,M  --var-mod UniMod:1,42.010565,*n --mass-acc 20  --mass-acc-ms1 10.0  --peptidoforms  --reanalyse  --relaxed-prot-inf --rt-profiling 
    """

    stub:
    """
    
    """
}