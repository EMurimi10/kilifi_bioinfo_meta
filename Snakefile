
rule quality_check:
    input:
        "/data_storage/seqtz-runs/cholera-kcmc/march2024_outbreak/05-fastq/meta_242526.fastq.gz"
    output:
        "/home/davis/kilifi_bioinfo_meta/output"
    conda: "nanoplot.yaml"
    shell:
        "NanoPlot --fastq {input} --loglength -o {output}"


# rule Filtering
# rule Decontamination
# rule Classification
# rule Abundance
# rule Reporting
# rule Visualization
