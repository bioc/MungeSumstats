# test_that("get_genome_builds works", {
# 
#     # Had to remove bc they took too long and put the overall build over 15m
# 
# 
#     eduAttainOkbayPth <- system.file("extdata", "eduAttainOkbay.txt",
#         package = "MungeSumstats"
#     )
#     sumstats_list <- list(ss1 = eduAttainOkbayPth,
#                           ss2 = eduAttainOkbayPth)
# 
#     ## Call uses reference genome as default with more than 2GB of memory,
#     ## which is more than what 32-bit Windows can handle so
#     # remove certain checks
#     is_32bit_windows <-
#         .Platform$OS.type == "windows" && .Platform$r_arch == "i386"
#     if (!is_32bit_windows) {
#         ref_genomes <- MungeSumstats::get_genome_builds(
#             sumstats_list = sumstats_list)
#         testthat::expect_true(all(ref_genomes=="GRCH37"))
#         testthat::expect_length(ref_genomes,2)
#     } else {
#         testthat::expect_true(is_32bit_windows)
#     }
# })
