% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sc_atac_tfidf.R
\name{sc_atac_tfidf}
\alias{sc_atac_tfidf}
\title{generating the UMAPs for sc-ATAC-Seq preprocessed data}
\usage{
sc_atac_tfidf(binary.mat, output_folder = NULL)
}
\arguments{
\item{binary.mat}{The final, filtered feature matrix in binary format}

\item{output_folder}{The path of the output folder}
}
\value{
None (invisible `NULL`)
}
\description{
Takes the binary matrix and generate a TF-IDF so the clutering can take place on the reduced dimentions.
}
\examples{
\dontrun{
sc_atac_tfidf(binary.mat = final_binary_matrix) 
}

}
