% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sc_atac_create_fragments.R
\name{read_cells}
\alias{read_cells}
\title{Read Cell barcode file}
\usage{
read_cells(cells)
}
\arguments{
\item{cells}{the file path to the barcode file. Assumes
one barcode per line or barcode csv.
Or, cells can be a comma delimited string of barcodes}
}
\value{
a character vector of the provided barcodes
}
\description{
Read Cell barcode file
}
