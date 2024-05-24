# Snakemake Metagenomics analysis workflow for long reads NGS datasets
rule rule_all:
    input:
        "/home/davis/kilifi_bioinfo_meta/quality_check",
        "/home/davis/kilifi_bioinfo_meta/mmseq2_output/report.html"

targetDB="/home/davis/kilifi_bioinfo_meta/db/Kalamari"
QUERY="/home/davis/kilifi_bioinfo_meta/data/assemmbly/assembly.fasta"

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

rule assembly:
    input:
        rules.decontamination.output
    output:
        directory("/home/davis/kilifi_bioinfo_meta/data/meta_242526_assembly")
    conda:
        "flye"
    shell:
        "flye --nano-raw {input} --out-dir {output} --meta"

rule mmseq2_classify:
    input:
        rules.assembly.output
    output:
        "/home/davis/kilifi_bioinfo_meta/mmseq2_output/report.html"
    conda: 
        "mmseq2"
    shell:
        """
        mkdir -p /home/davis/kilifi_bioinfo_meta/mmseq2_output
        mmseqs createdb {QUERY} reads
        mmseqs taxonomy reads {targetDB} /home/davis/kilifi_bioinfo_meta/mmseq2_output/lca_result tmp --search-type 3
        mmseqs taxonomyreport {targetDB} /home/davis/kilifi_bioinfo_meta/mmseq2_output/lca_result {output} --report-mode 1
        """