
rule quality_check:
    input:
        "data/meta_242526.fastq.gz"
    output:
        directory("/home/davis/kilifi_bioinfo_meta/output1")
    conda: 
        "nanoplot"
    shell:
        "NanoPlot --fastq {input} --loglength -o {output}"


# rule Filtering
# rule Decontamination
# rule Classification
# rule Abundance
# rule Reporting
# rule Visualization
