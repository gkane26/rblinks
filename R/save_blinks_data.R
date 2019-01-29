#' Save data frame of foraging data to a file
#'
#'
#' @param dat data frame or list of data frames created by med_to_dt
#' @param path string (optional); complete path to save directory, if not given, uses current working directory
#' @param name string (optional); base name of file. if not provided, default is 'subject_date' of first row
#' @param as_csv logical; if true, save as .csv file. if false, save as .Rdata file with a data frame called 'forage_data'. default=false
#'
#' @return complete path to saved file
#' @export
save_blinks_data = function(dat, path=getwd(), name="", as_csv=F){

  if(class(dat)[1]=="list"){
    dat = rbindlist(dat)
  }

  if(name==""){
    name = paste(dat[1,subject], dat[1,date], sep="_")
  }
  name = file.path(path, name)

  if(as_csv){
    name = paste(name, ".csv", sep="")
    write.csv(dat, name)
  }else{
    name = paste(name, ".Rdata", sep="")
    forage_data = dat
    saveRDS(forage_data, name)
  }

  return(name)
}
