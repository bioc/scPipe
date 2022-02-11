# scPipe

[![Travis build status](https://travis-ci.org/LuyiTian/scPipe.svg?branch=master)](https://travis-ci.org/LuyiTian/scPipe)
[![Coverage
Status](https://codecov.io/gh/LuyiTian/scPipe/branch/master/graph/badge.svg)](https://codecov.io/gh/LuyiTian/scPipe)

<img src=inst/scPipe.png height="200">

scPipe is an R package that allows barcode demultiplexing, transcript mapping and quality control of raw sequencing data generated by 
* multiple 3 prime end sequencing protocols for scRNA-Seq including CEL-seq, MARS-seq, Chromium 10x and Drop-seq and,
* various scATAC-Seq platforms including sci_ATAC, sc-ATAC, 10X, etc. 

RNA-Seq module of scPipe produces a count matrix that is essential for downstream analysis along with a user-friendly HTML report that summarises data quality. These results can be used as input for downstream analyses including normalization, visualization and statistical testing.

ATAC-Seq module of scPipe contains capabilities of pre-processing scATAC-Seq data through scPipe. This functionality allows barcode demultiplexing, peak calling and quality control of raw sequencing data generated by multiple single-cell ATAC-Seq sequencing protocols including 10X, scATAC-Seq, dscATAC-Seq, dsciATAC-Seq, sciATAC-Seq, plate-based ATAC-Seq and scHTS-Seq.
ATAC-Seq module also produces a feature-barcode count matrix that is essential for downstream analysis along with a user-friendly HTML report that summarises data quality.

The scATAC-Seq preprocessing module of the package is under active development. Feel free to ask any questions or submit a pull request.

* [01/04/2021] scPipe now uses *samtools* to remove duplicates from scATAC-Seq data
* [01/04/2021] scPipe now uses *MACS3* for scATAC-Seq peak calling
* [01/04/2021] scPipe now uses *sinto* for scATAC-seq fragment file generation
* [15/02/2021] scPipe scATAC-Seq module also now uses the *SingleCellExperiment* class.
* [21/01/2021] now uses [macsr](https://github.com/macs3-project/MACSr) for peak calling (yet via R developmental version, R.0.1) 
* [03/01/2021] add the cell calling function to scATAC-Seq module for ScPipe (using the package [DropletUtils](https://bioconductor.org/packages/release/bioc/html/DropletUtils.html))
* [12/12/2020] complete 1st version of scATAC-Seq module for ScPipe
* [13/05/2020] initiate scATAC-Seq module for scPipe
* [21/09/2017] scPipe now uses the *SingleCellExperiment* class.

## Installation

### From Bioconductor

```
if (!requireNamespace("BiocManager", quietly=TRUE))
    install.packages("BiocManager")
BiocManager::install("scPipe")
```

### From GitHub (Developmental version)

```{r}
install.packages("devtools")
devtools::install_github("shaniAmare/scPipe")
```

## Getting started

The general workflow of scPipe is illustrated in the following figure:

<img src=inst/workflow_combined.png>

## Concept for scRNA-Seq preprocessing

* The `sc_trim_barcode` function will reformat each read and put the cell barcode and UMI sequence into the fastq read names: `@ACGATCGA_TAGAGC#SIMULATE_SEQ::002::000::0000::0
AAGACGTCTAAGGGCGGTGTACACCCTTTTGAGCAATGATTGCACAACCTGCGATCACCTTATACAGAATTAT+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`

* After alignment, the `sc_exon_mapping` function will put the cell barcode and UMI into the bam file with different tags, together with gene information: `AAAGTCAA_AACTCA#SIMULATE_SEQ::007::000::0013::10        0       ERCC-00171      142     40      73M     *       0       0       GCCTCGGGAATAAGCTGACGGTGACAAGGTTTCCCCCTAATCGAGACGCTGCAATAACACAGGGGCATACAGT AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA       HI:i:1  NH:i:1  NM:i:0  GE:Z:ERCC-00171 YC:Z:AAAGTCAA   YM:Z:AACTCA     YE:i:-364`. In this example the cell barcode is AAAGTCAA with tag `YC`, the UMI is AACTCA with tag `YM` and the gene that this read maps to is `ERCC-00171` with tag `GE`. This read is located 364 bp upstream of the transcription end site (TES), which is stored in the `YE` tag.

* The `sc_demultiplex` function will look for the cell barcode in BAM file (by default in the `YC` tag) and compare it against the known cell barcode annotation file, which is a csv file consisting of two columns. The first column is the cell name and second column is the cell barcode. For Chromium 10x and Drop-seq data we can run `sc_detect_bc` to find the barcodes and generate the cell barcode annotation file before running `sc_demultiplex`. An example barcode annotation file is available in the package from `system.file("extdata", "barcode_anno.csv", package = "scPipe")`. The output of `sc_demultiplex` will be multiple csv files corresponding to each cell. Each file has three columns, the first of which contains the gene id, the second column contains the UMI sequence and third column gives the relative location of the read to the TES. These files are used for `sc_gene_counting`.

For further examples see the vignette.

## Concept for scATAC-Seq preprocessing

* The `sc_atac_trim_barcode` function will reformat each read and put the cell barcode and UMI sequence into the fastq read names: `@ACGATCGA_TAGAGC#SIMULATE_SEQ::002::000::0000::0
AAGACGTCTAAGGGCGGTGTACACCCTTTTGAGCAATGATTGCACAACCTGCGATCACCTTATACAGAATTAT+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`

* The `sc_atac_aligning` function will align the reformatted fastq files and create bam files.

* After alignment, the `sc_atac_bam_tagging` function will put the cell barcode (and UMI, if avaialble) into the bam file with different tags: `AAAGTCAA_AACTCA#SIMULATE_SEQ::007::000::0013::10        0       ERCC-00171      142     40      73M     *       0       0       GCCTCGGGAATAAGCTGACGGTGACAAGGTTTCCCCCTAATCGAGACGCTGCAATAACACAGGGGCATACAGT AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA       HI:i:1  NH:i:1  NM:i:0  GE:Z:ERCC-00171 YC:Z:AAAGTCAA   YM:Z:AACTCA     YE:i:-364`. In this example the cell barcode is AAAGTCAA with tag `YC`, the UMI is AACTCA with tag `YM` and the gene that this read maps to is `ERCC-00171` with tag `GE`. This read is located 364 bp upstream of the transcription end site (TES), which is stored in the `YE` tag.

* The `sc_atac_peak_calling` function can be used to call peaks using macsr via Linux/Mac environment(). However, macsr is yet not compatible with Windows.

* The `sc_atac_feature_counting` function will generate a feature-count matrix for the alignment and an input feature file (a genome, a bed file format of features, for example one generated through `sc_atac_peak_calling` or MACS2/3). If the feature file is a genome.fasta file a genome_bin approach is used to create the features. It would also generate quality statistics that will get stored in the `scPipe_atac_stats` folder within the working directory. Cell calling is a function implemented in this function to identify the "true" cells. 

* The function `sc_atac_create_sce` generates the `Single Cell Experiment` object from the feature-count matrix aand the quality scores acquired throughout the pipeline. It also aloows the user to generate a HTML report which can alternatively be created by the `sc_atac_create_report` function.

* The function `sc_atac_create_report` can be run within the `sc_atac_create_sce` or independently to create a report based on th quality statistics avaialble through the processed pipeline.

A minimal example for scATAC-Seq module of scPipe is available [here](minimal_atac_example.md). For further examples see the relevant vignette.

## Acknowledgments
This package is inspired by the `scater`, `scran` and `scATAC=pro` packages. The idea to put cell barcode and UMI sequences into the BAM file is from [Drop-seq tools](http://mccarrolllab.com/dropseq/). Also some features of the scPipe-ATAC module were inspired by the [scATAC-pro](https://github.com/wbaopaul/scATAC-pro) and [SnapTools](https://github.com/r3fang/SnapTools) packages. We thank Dr Aaron Lun for suggestions on package development.
