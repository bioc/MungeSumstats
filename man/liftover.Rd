% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/liftover.R
\name{liftover}
\alias{liftover}
\title{Genome build liftover}
\source{
\href{https://doi.org/doi:10.18129/B9.bioc.liftOver}{liftOver}

\href{https://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/}{
UCSC chain files}

\href{https://ftp.ensembl.org/pub/assembly_mapping/homo_sapiens/}{
Ensembl chain files}
}
\usage{
liftover(
  sumstats_dt,
  convert_ref_genome,
  ref_genome,
  chain_source = "ensembl",
  imputation_ind = TRUE,
  chrom_col = "CHR",
  start_col = "BP",
  end_col = start_col,
  as_granges = FALSE,
  style = "NCBI",
  local_chain = NULL,
  verbose = TRUE
)
}
\arguments{
\item{sumstats_dt}{data table obj of the summary statistics
file for the GWAS.}

\item{convert_ref_genome}{name of the reference genome to convert to
("GRCh37" or "GRCh38"). This will only occur if the current genome build does
not match. Default is not to convert the genome build (NULL).}

\item{ref_genome}{name of the reference genome used for the GWAS ("GRCh37" or
"GRCh38"). Argument is case-insensitive. Default is NULL which infers the
reference genome from the data.}

\item{chain_source}{chain file source used ("ucsc" as default, or "ensembl")}

\item{imputation_ind}{Binary Should a column be added for each imputation
step to show what SNPs have imputed values for differing fields. This
includes a field denoting SNP allele flipping (flipped). On the flipped
value, this denoted whether the alelles where switched based on
MungeSumstats initial choice of A1, A2 from the input column headers and thus
may not align with what the creator intended.\strong{Note} these columns will be
in the formatted summary statistics returned. Default is FALSE.}

\item{chrom_col}{Name of the chromosome column in
\code{sumstats_dt} (e.g. "CHR").}

\item{start_col}{Name of the starting genomic position
column in \code{sumstats_dt} (e.g. "POS","start").}

\item{end_col}{Name of the ending genomic position
column in \code{sumstats_dt} (e.g. "POS","end").
Can be the same as \code{start_col} when \code{sumstats_dt}
only contains SNPs that span 1 base pair (bp) each.}

\item{as_granges}{Return results as \link[GenomicRanges]{GRanges}
instead of a \link[data.table]{data.table} (default: \code{FALSE}).}

\item{style}{Style to return \link[GenomicRanges]{GRanges} object in
(e.g.  "NCBI" = 4; "UCSC" = "chr4";) (default: \code{"NCBI"}).}

\item{local_chain}{Path to local chain file to use instead of downlaoding.
Default of NULL i.e. no local file to use. NOTE if passing a local chain file
make sure to specify the path to convert from and to the correct build like
GRCh37 to GRCh38. We can not sense check this for local files. The chain file
can be submitted as a gz file (as downloaed from source) or unzipped.}

\item{verbose}{Print messages.}
}
\value{
Lifted summary stats in \code{data.table}
or \link[GenomicRanges]{GRanges} format.
}
\description{
Transfer genomic coordinates from one genome build to another.
}
\examples{
sumstats_dt <- MungeSumstats::formatted_example()

sumstats_dt_hg38 <- liftover(sumstats_dt=sumstats_dt, 
                             ref_genome = "hg19",
                             convert_ref_genome="hg38")
}
