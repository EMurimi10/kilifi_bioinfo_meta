# Snakemake Metagenomics analysis workflow for long reads NGS datasets
rule rule_all:
    input:
        "/home/davis/kilifi_bioinfo_meta/quality_check",
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_filtered.fastq.gz",
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_decontaminated",
        "/home/davis/kilifi_bioinfo_meta/results/metamaps"

# threads = 10
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

rule assembly:
    input:
        "/home/davis/kilifi_bioinfo_meta/data/meta_242526_filtered.fastq.gz"
    output:
        directory("/home/davis/kilifi_bioinfo_meta/data/meta_242526_assembly")
    conda:
        "flye"
    shell:
        "flye --nano-raw {input} --out-dir {output} --meta"

    
rule decontamination:
    input:
        rules.filtering.output 
    output:
        directory("/home/davis/kilifi_bioinfo_meta/data/meta_242526_decontaminated")
    conda: 
        "hostile"
    shell:
        "hostile clean --fastq1 {input} --aligner minimap2 --out-dir {output}"

rule mmseq2_classify:
    input:
        rules.decontamination.output
    output:
        directory("/home/davis/kilifi_bioinfo_meta/results/mmseqs2")
    conda: 
        "mmseqs2"
    shell:
        mmseqs taxonomy <i:queryDB> <i:targetDB> <o:taxaDB> tmp [options]


# rule metamaps_classify:
#     input:
#         database="databases/miniSeq+H/DB.fa",
#         fastq_in="data/meta_242526.fastq.gz",
#         database_dir="databases/miniSeq+H"
#     output:
#         directory("/home/davis/kilifi_bioinfo_meta/results/metamaps")
#     params:
#         threads=5
#     resources:
#         mem_mb=16000,
#         disk_mb=50000
#     log:
#         "logs/map_directly.log"
#     #threads:{threads}
#     conda:
#         "metamaps"
#     shell:
#        """
#        metamaps mapDirectly -t {params.threads} --all -r {input.database} -q {input.fastq_in} -o {output}/classified --maxmemory 20
#        metamaps classify -t {params.threads} --mappings {output}/classified --DB {input.database_dir}
#        """  