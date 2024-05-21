
rule quality_check:
    input:
        "data/N0037_barcode01.fastq.gz"
    output:
        "/home/davis/kilifi_bioinfo_meta/output1"
    conda: 
        "nanoplot.yaml"
    shell:
        "NanoPlot --fastq {input} --loglength -o {output}"


# rule Filtering
# rule Decontamination
# rule Classification
# rule Abundance
# rule Reporting
# rule Visualization
