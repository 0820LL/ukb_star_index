// Declare syntax version
nextflow.enable.dsl=2

process STAR_GENOMEGENERATE {

    container = "${projectDir}/../singularity-images/depot.galaxyproject.org-singularity-mulled-v2-1fa26d1ce03c295fe2fdcf85831a92fbcbd7e8c2-1df389393721fc66f3fd8778ad938ac711951107-0.img"

    input:
    path fasta
    path gtf

    output:
    path "*.tar.gz"

    script:
    """
    mkdir star_index
    STAR \\
        --runMode genomeGenerate \\
        --genomeDir star_index/ \\
        --genomeFastaFiles $fasta \\
        --sjdbGTFfile $gtf \\
        --runThreadN ${params.threads_num} 
    tar -czvf star_index.tar.gz star_index
    rm -rf star_index
    cp star_index.tar.gz ${launchDir}/${params.outdir}/
    """
}

workflow{
    fasta = Channel.of(params.fasta)
    gtf   = Channel.fromPath(params.gtf)
    STAR_GENOMEGENERATE(fasta, gtf)
}

