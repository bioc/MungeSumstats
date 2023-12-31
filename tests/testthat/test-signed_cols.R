test_that("will fail without a signed column", {
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
        # read it in and combine CHR BP columns
        sumstats_dt <- data.table::fread(file)
        # Remove signed column - BETA
        sumstats_dt[, Beta := NULL]
        data.table::fwrite(x = sumstats_dt, file = file, sep = "\t")
        # Run MungeSumstats code
        error_return <-
            tryCatch(MungeSumstats::format_sumstats(file,
                ref_genome = "GRCh37",
                on_ref_genome = FALSE,
                strand_ambig_filter = FALSE,
                bi_allelic_filter = FALSE,
                allele_flip_check = FALSE,
                dbSNP=144
            ),
            error = function(e) e,
            warning = function(w) w
            )
        expect_equal(is(error_return, "error"), TRUE)
    }    
    else{
        expect_equal(is_32bit_windows, TRUE)
    }
})
