#' Ensure that SNP ids don't have multiple rs ids on one line
#'
#' @inheritParams format_sumstats  
#' @param log_files list of log file locations
#' @return list containing sumstats_dt, the modified summary statistics data 
#' table object and the log file list.
#' @keywords internal
#' @importFrom data.table :=
check_multi_rs_snp <- function(sumstats_dt, path, remove_multi_rs_snp, 
                                imputation_ind,log_folder_ind,check_save_out,
                                tabix_index, nThread, log_files){
    SNP = convert_multi_rs_SNP = NULL
    message("Checking for multiple RS IDs on one row.")
    col_headers <- names(sumstats_dt)
    if(sum("SNP" %in% col_headers)==1 && sum(grepl("_rs",sumstats_dt$SNP))>0){
        if(!remove_multi_rs_snp){ #take first
            msg<-paste0(sum(grepl("_rs",sumstats_dt$SNP))," SNPs found with ",
                        " multiple RS IDs on one row, the first will be ",
                        "taken. If you would rather remove these SNPs set\n",
                        "`remove_multi_rs_snp`=TRUE")
            message(msg)
            #if user specifies add a column to notify of the imputation
            if(imputation_ind)
                sumstats_dt[grepl("_rs",SNP),convert_multi_rs_SNP:=TRUE]
            sumstats_dt[grepl("_rs",SNP),SNP:=gsub("\\_rs.*","\\",SNP)]
        }
        else{ # remove rows
            msg<-paste0(sum(grepl("_rs",sumstats_dt$SNP))," SNPs found with",
                        " multiple RS IDs on one row, these will be ",
                        "removed. If you would rather take the first RS ID ",
                        "set\n`remove_multi_rs_snp`=FALSE")
            #If user wants log, save it to there
            if(log_folder_ind){
                name <- "snp_multi_rs_one_row"
                name <- get_unique_name_log_file(name=name,log_files=log_files)
                write_sumstats(sumstats_dt = sumstats_dt[grepl("_rs",SNP),], 
                               save_path=
                                   paste0(check_save_out$log_folder,
                                            "/",name,
                                          check_save_out$extension),
                               sep=check_save_out$sep,
                               tabix_index = tabix_index,
                               nThread = nThread)
                log_files[[name]] <- 
                    paste0(check_save_out$log_folder,"/",name,
                            check_save_out$extension)
            }    
            message(msg)
            sumstats_dt <- sumstats_dt[!grepl("_rs",SNP),]
        }
        
        return(list("sumstats_dt"=sumstats_dt,"log_files"=log_files))
    }
    else{
        return(list("sumstats_dt"=sumstats_dt,"log_files"=log_files))
    }
}