rule rule_all:
    input:
        "/home/davis/kilifi_bioinfo_meta/quality_check",
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_filtered.fastq.gz",
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_decontaminated.bam"

rule quality_check:
    input:
        "data/meta_242526.fastq.gz"
    output:
<<<<<<< HEAD
        directory("/home/davis/kilifi_bioinfo_meta/output1")
=======
        directory("/home/davis/kilifi_bioinfo_meta/quality_check")
>>>>>>> a993da9 (updated snakefile with more rules)
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
        query="data/meta_242526_filtered.fastq.gz",
        ref="data/meta_242526.fastq.gz"
    output:
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_decontaminated.bam"
    conda: 
        "minimap2"
    shell:
        "minimap2 -ax map-ont {input.ref} {input.query} | samtools sort -@ 8 -o {output} > {output}"

rule filter_decontaminated:
    input:
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_decontaminated.bam"
    output:
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_filtered_decontaminated.bam"
    conda: 
        "samtools"
    shell:
        "samtools view -h -b -q 10 {input} | samtools sort -@ 8 -o {output}"

rule metamaps_classifiaction:
    input:
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_filtered_decontaminated.bam"
    output:
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_classified.bam"
    conda: 
        "metamaps"
    shell:
        "metamaps -i {input} -o {output}"

# rule Classification
# rule Abundance
# rule Reporting
# rule Visualization
