% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_drop_indels.R
\name{check_drop_indels}
\alias{check_drop_indels}
\title{Drop Indels from summary statistics}
\source{
\code{
sumstats_dt <- MungeSumstats:::formatted_example()
sumstats <- check_drop_indels(sumstats_dt = sumstats_dt, 
                              drop_indels = TRUE)
}
}
\usage{
check_drop_indels(
  sumstats_dt,
  drop_indels,
  path,
  log_folder_ind,
  check_save_out,
  tabix_index,
  nThread,
  log_files
)
}
\arguments{
\item{sumstats_dt}{data table obj of the summary statistics file for the GWAS}

\item{drop_indels}{Binary, should any indels found in the sumstats be
dropped? These can not be checked against a reference dataset and will have
the same RS ID and position as SNPs which can affect downstream analysis.
Default is False.}

\item{path}{Filepath for the summary statistics file to be formatted. A
dataframe or datatable of the summary statistics file can also be passed
directly to MungeSumstats using the path parameter.}

\item{log_folder_ind}{Binary Should log files be stored containing all
filtered out SNPs (separate file per filter). The data is outputted in the
same format specified for the resulting sumstats file. The only exception to
this rule is if output is vcf, then log file saved as .tsv.gz. Default is
FALSE.}

\item{tabix_index}{Index the formatted summary statistics with
\href{http://www.htslib.org/doc/tabix.html}{tabix} for fast querying.}

\item{nThread}{Number of threads to use for parallel processes.}
}
\value{
list containing sumstats_dt,
the modified summary statistics data table object
}
\description{
Drop Indels from summary statistics
}
\keyword{internal}
