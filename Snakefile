rule rule_all:
    input:
        "/home/davis/kilifi_bioinfo_meta/quality_check",
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_filtered.fastq.gz",
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_decontaminated"

rule quality_check:
    input:
        "data/meta_242526.fastq.gz"
    output:
        directory("/home/davis/kilifi_bioinfo_meta/quality_check")
    conda: 
        "nanoplot"
    shell:
        "NanoPlot --fastq {input} --loglength -o {output}"


rule filtering:
    input:
        "data/meta_242526.fastq.gz"
    output:
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_filtered.fastq.gz"
    conda: 
        "filtlong"
    shell:
        "filtlong --min_length 100 --keep_percent 90  {input} | gzip > {output}"

rule decontamination:
    input:
        rules.filtering.output 
    output:
        directory("/home/davis/kilifi_bioinfo_meta/data/meta_242526_decontaminated")
    conda: 
        "hostile"
    shell:
        "hostile clean --fastq1 {input} --aligner minimap2 --out-dir {output}"

# rule metamaps_classifiaction:
#     input:
#         "/home/davis/kilifi_bioinfo_meta/data/meta_242526_filtered_decontaminated.bam"
#     output:
#         "/home/davis/kilifi_bioinfo_meta/data/meta_242526_classified.bam"
#     conda: 
#         "metamaps"
#     shell:
#         "metamaps -i {input} -o {output}"

# rule Classification
# rule Abundance
# rule Reporting
# rule Visualization
