test_that("Input has correct format", {
    ## Call uses reference genome as default with more than 2GB of memory,
    ## which is more than what 32-bit Windows can handle so remove tests
    is_32bit_windows <-
        .Platform$OS.type == "windows" && .Platform$r_arch == "i386"
    if (!is_32bit_windows) {
        file <- tempfile()
        # write the Educational Attainment GWAS to a temp file for testing
        eduAttainOkbay <- readLines(system.file("extdata", "eduAttainOkbay.txt",
            package = "MungeSumstats"
        ))
        writeLines(eduAttainOkbay, con = file)
        # Run MungeSumstats code
        reformatted <- MungeSumstats::format_sumstats(file,
            ref_genome = "GRCh37",
            on_ref_genome = FALSE,
            strand_ambig_filter = FALSE,
            bi_allelic_filter = FALSE,
            allele_flip_check = FALSE,
            dbSNP=144
        )
        reformatted_lines <- readLines(reformatted)
        # Only issue with eduAttainOkbay is the SNP ID name so update before check
        len_eduAttainOkbay <- length(eduAttainOkbay)
        # setequal ignores order - SNP rows are reordered
        expect_equal(setequal(
            reformatted_lines[2:length(reformatted_lines)],
            eduAttainOkbay[2:len_eduAttainOkbay]
        ), TRUE)
        headers_eduAttainOkbay <- "SNP\tCHR\tBP\tA1\tA2\tFRQ\tBETA\tSE\tP"
        expect_equal(reformatted_lines[1], headers_eduAttainOkbay)
    }    
    else{
        expect_equal(is_32bit_windows, TRUE)
    }
})
