#' @name sc_sample_data
#' @title a small sample scRNA-seq counts dataset to 
#' demonstrate capabilities of scPipe
#' @description This data set contains counts for high variable genes for 
#' 100 cells. The cells have different cell types. The data contains
#' raw read counts. The cells are chosen randomly from 384 cells and
#' they did not go through quality controls. The rows names are 
#' Ensembl gene ids and the columns are cell names, which is the wall
#' position in the 384 plates.
#' @return NULL, but makes a matrix of count data
#' @docType data
#' @format a matrix instance, one row per gene.
#' @source Christin Biben (WEHI). She FACS sorted cells from several immune
#' cell types including B cells, granulocyte and some early progenitors. 
#' @author Luyi Tian
#' @examples 
#' # use the example dataset to perform quality control
#' data("sc_sample_data")
#' data("sc_sample_qc")
#' sce = SingleCellExperiment(assays = list(counts = as.matrix(sc_sample_data)))
#' organism(sce) = "mmusculus_gene_ensembl"
#' gene_id_type(sce) = "ensembl_gene_id"
#' QC_metrics(sce) = sc_sample_qc
#' demultiplex_info(sce) = cell_barcode_matching
#' UMI_dup_info(sce) = UMI_duplication
#' sce = detect_outlier(sce)
#' 
#' plot_QC_pairs(sce)
#' 
NULL