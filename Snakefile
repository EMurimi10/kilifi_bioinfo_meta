# Snakemake Metagenomics analysis workflow for long reads NGS datasets
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

rule metamaps_classify:
    input:
        database="databases/miniSeq+H/DB.fa",
        fastq_in="input.fastq"
        database_dir="databases/miniSeq+H"
    output:
        wimp="{params.stem}.EM.WIMP"
        r2tax="{params.stem}.EM.reads2Taxon"
        r2tax_kro="{params.stem}.EM.reads2Taxon.krona"
        cont_cov="{params.stem}.EM.contigCoverage"
        lIDs_map="{params.stem}.EM.lengthAndIdentitiesPerMappingUnit"
        em="{params.stem}.EM"
        unk_sp="{params.stem}.EM.evidenceUnknownSpecies"
    params:
        stem="classify_results",
        threads=5,
    resources:
        mem_mb=16000,
        disk_mb=10000
    log:
        "logs/map_directly.log"
    threads: 5

    shell:
        "metamaps mapDirectly -t {params.threads} --all -r {input.database} -q {input.fastq_in}.fastq -o {params.stem} --maxmemory 20",
        "metamaps classify -t {params.threads} --mappings {params.stem} --DB {input.database_dir}"
