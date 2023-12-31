% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_allele_merge.R
\name{check_allele_merge}
\alias{check_allele_merge}
\title{Ensure that A1:A2 or A1/A2 or A1>A2 or A2>A1 aren't merged into 1 column}
\usage{
check_allele_merge(sumstats_dt, path)
}
\arguments{
\item{sumstats_dt}{data table obj of the summary statistics file for the GWAS}

\item{path}{Filepath for the summary statistics file to be formatted}
}
\value{
list containing sumstats_dt, the modified summary
statistics data table object.
}
\description{
Ensure that A1:A2 or A1/A2 or A1>A2 or A2>A1 aren't merged into 1 column
}
\keyword{internal}
