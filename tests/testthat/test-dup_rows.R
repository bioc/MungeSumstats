test_that("Handle duplicate rows based on rs ID", {
    ## Call uses reference genome as default with more than 2GB of memory,
    ## which is more than what 32-bit Windows can handle so remove tests
    is_32bit_windows <-
        .Platform$OS.type == "windows" && .Platform$r_arch == "i386"
    if (!is_32bit_windows) {
        file <- tempfile()
        # Duplicate rows and check output is the same
        eduAttainOkbay <- readLines(system.file("extdata", "eduAttainOkbay.txt",
            package = "MungeSumstats"
        ))
        eduAttainOkbay_missing <- eduAttainOkbay
        len <- length(eduAttainOkbay_missing)
        eduAttainOkbay_missing <- c(
            eduAttainOkbay_missing,
            eduAttainOkbay_missing[2:len]
        )
        # write the Educational Attainment GWAS to a temp file for testing
        writeLines(eduAttainOkbay_missing, con = file)
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
        # Should equal org
        writeLines(eduAttainOkbay, con = file)
        org <- MungeSumstats::format_sumstats(file,
            ref_genome = "GRCh37",
            on_ref_genome = FALSE,
            strand_ambig_filter = FALSE,
            bi_allelic_filter = FALSE,
            allele_flip_check = FALSE,
            dbSNP=144
        )
        org_lines <- readLines(org)
        # check equal regardless of order
        expect_equal(setequal(reformatted_lines, org_lines), TRUE)
    
        #---------------
        # Duplicate base-pair position and check output is the same
        eduAttainOkbay_missing <- eduAttainOkbay
        # add in one row again and change rs id so position removes it
        # row 77
        eduAttainOkbay_missing <-
            c(
                eduAttainOkbay_missing,
                "rs9556959\t13\t99100046\tT\tC\t0.5019\t-0.014\t0.003\t6.617e-08"
            )
        # write the Educational Attainment GWAS to a temp file for testing
        writeLines(eduAttainOkbay_missing, con = file)
        # Run MungeSumstats code
        reformatted <- MungeSumstats::format_sumstats(file,
            ref_genome = "GRCh37",
            on_ref_genome = FALSE,
            strand_ambig_filter = FALSE,
            bi_allelic_filter = TRUE,
            allele_flip_check = FALSE,
            dbSNP=144
        )
        reformatted_lines <- readLines(reformatted)
        # check equal regardless of order
        expect_equal(setequal(reformatted_lines, org_lines), TRUE)
    }    
    else{
        expect_equal(is_32bit_windows, TRUE)
        expect_equal(is_32bit_windows, TRUE)
    }
})
