#!/usr/bin/env nextflow

process COMBINE_STATS {
    container "docker.io/rocker/tidyverse"

    input:
    path(stats)
    
    output:
    path('combine_stats.csv')
    path('combine_stats.png')

    script:
    """
    # We don't have to provide the full path to this script as it is in the root `bin` dir of the project
    # See: https://www.nextflow.io/docs/latest/faq.html#how-do-i-invoke-custom-scripts-and-tools

    combine_stats.r ${stats}
    """
}
