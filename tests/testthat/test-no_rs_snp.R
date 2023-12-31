test_that("Check SNP ID formatting", {
    ## The following test uses more than 2GB of memory, which is more
    ## than what 32-bit Windows can handle:
    is_32bit_windows <- .Platform$OS.type == "windows" ##&&
        ##.Platform$r_arch == "i386"
    if (!is_32bit_windows) {
        file <- tempfile()
        # write the Educational Attainment GWAS to a temp file for testing
        eduAttainOkbay <- readLines(system.file("extdata", "eduAttainOkbay.txt",
                                                package = "MungeSumstats"
        ))
        writeLines(eduAttainOkbay, con = file)
        # read it in and drop CHR BP columns
        sumstats_dt <- data.table::fread(file)
        # Keep Org to validate values
        sumstats_dt_missing <- data.table::copy(sumstats_dt)
        # impute CHR:BP for SNP for first row to ensure MungeSumstats gets SNP
        sumstats_dt_missing[
            MarkerName == "rs12987662",
            MarkerName := paste0(CHR, ":", POS)
        ]
        # have copy where CHR & POS not removed
        sumstats_dt_missing2 <- data.table::copy(sumstats_dt_missing)
        # Now remove CHR POS
        sumstats_dt_missing[, CHR := NULL]
        sumstats_dt_missing[, POS := NULL]
        # Also add row with incorrect format for SNP ID which should be removed
        sumstats_dt_missing[
            MarkerName == "rs9320913",
            MarkerName := "9320913"
        ]
        sumstats_dt_missing2[
            MarkerName == "rs9320913",
            MarkerName := "9320913"
        ]
        
        # try third with check_row_snp and snp_ids_are_rs_ids=TRUE
        sumstats_dt_missing3 <- data.table::copy(sumstats_dt)
        sumstats_dt_missing3[, MarkerName := substr(MarkerName, 3, 
                                                    nchar(MarkerName))]
        
        data.table::fwrite(x = sumstats_dt_missing, file = file, sep = "\t")
        file2 <- tempfile()
        data.table::fwrite(x = sumstats_dt_missing2, file = file2, sep = "\t")
        file3 <- tempfile()
        data.table::fwrite(x = sumstats_dt_missing3, file = file3, sep = "\t")
        # Run MungeSumstats code
        reformatted <- MungeSumstats::format_sumstats(file,
            ref_genome = "GRCh37",
            on_ref_genome = FALSE,
            strand_ambig_filter = FALSE,
            bi_allelic_filter = FALSE,
            allele_flip_check = FALSE,
            dbSNP=144
        )
        res_dt <- data.table::fread(reformatted)

        reformatted2 <- MungeSumstats::format_sumstats(file2,
            ref_genome = "GRCh37",
            on_ref_genome = FALSE,
            strand_ambig_filter = FALSE,
            bi_allelic_filter = FALSE,
            allele_flip_check = FALSE,
            dbSNP=144
        )
        res_dt2 <- data.table::fread(reformatted2)

        # will give error as all ID's don't have rs and 
        # snp_ids_are_rs_ids=TRUE set
        fail_return <-
            tryCatch(MungeSumstats::format_sumstats(file3,
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

        # run org
        writeLines(eduAttainOkbay, con = file)
        org <- MungeSumstats::format_sumstats(file,
            ref_genome = "GRCh37",
            on_ref_genome = FALSE,
            strand_ambig_filter = FALSE,
            bi_allelic_filter = FALSE,
            allele_flip_check = FALSE,
            dbSNP=144
        )
        org_dt <- data.table::fread(org)
        data.table::setkey(org_dt, SNP)
        data.table::setkey(res_dt, SNP)
        data.table::setkey(res_dt2, SNP)
        # check equal with corrupted SNP ID removed
        expect_equal(all.equal(org_dt[SNP != "rs9320913", ], res_dt,
            ignore.row.order = TRUE
        ), TRUE)
        expect_equal(all.equal(org_dt, res_dt2,
            ignore.row.order = TRUE
        ), TRUE)
        expect_equal(is(fail_return, "error"), TRUE)
    } else {
        expect_equal(is_32bit_windows, TRUE)
        expect_equal(is_32bit_windows, TRUE)
        expect_equal(is_32bit_windows, TRUE)
    }
})
