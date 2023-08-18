
library(tools)
library(plumber)
library(jsonlite)
library(streamFind)
library(plotly)

# DEMO TODOS:
# TODO: Save stuff in sessions --> add to cache.
# TODO: Create docker containers for server and frontend --> create image

#*@filter cors
cors <- function(req, res) {

  res$setHeader("Access-Control-Allow-Origin", "*")

  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods","*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE")
    res$setHeader("Access-Control-Allow-Headers", "Content-Type")
    res$status <- 200
    return(list())
  } else {
    plumber::forward()
  }
}


#* @get /files_project
function() {
    filesx <- list.files(path = "/Users/ammar/Desktop/streamFind", pattern = "\\.mzML$", full.names = TRUE, recursive = FALSE)
    folders <- list.dirs(path = "/Users/ammar/Desktop/streamFind", full.names = TRUE, recursive = FALSE)
    file_names <- basename(filesx)
    folder_names <- basename(folders)
    filesandfolders <- c(file_names, folder_names)
  return(filesandfolders)
}

#* @post /open_folder
function(req) {
  folder_name <- req$body$name
  print(folder_name)
  folder_path <- paste0("/Users/ammar/Desktop/streamFind/", folder_name)
  filesx <- list.files(path = folder_path, pattern = "\\.mzML$", full.names = TRUE, recursive = FALSE)
  folders <- list.dirs(path = folder_path, full.names = TRUE, recursive = FALSE)
  file_names <- basename(filesx)
  folder_names <- basename(folders)
  filesandfolders <- c(file_names, folder_names)
  return(filesandfolders)
}



#* MsData for a given file
#* @post /msdata
function(req) {
  fileArray <- req$postBody
  fileNames <- fromJSON(fileArray)
  cache_key <- paste(sort(fileNames), collapse = "_")
  print(cache_key)
  # Check if cached results exist for the given files
  if (file.exists(paste0(cache_key, ".rds"))) {
    # If cached results exist, load and return them
    cached_result <- readRDS(paste0(cache_key, ".rds"))
    print("loading from cache...")
    return(cache_key)
  } else {
  folderPath <- "/Users/ammar/Desktop/streamFind/app/backend/sample mzml"
  filesInFolder <- list.files(folderPath, full.names = TRUE)
  matchingFiles <- file.path(folderPath, fileNames)
  matchingFiles <- matchingFiles[matchingFiles %in% filesInFolder]
  ms <- streamFind::MassSpecData$new(files=matchingFiles)
  saveRDS(ms, paste0(cache_key, ".rds"))
  print("saving cache...")
  return(cache_key)
  }
}

#* Getting details for MsData
#* @post /msdatadetails
function(req) {
  fileArray <- req$postBody
  fileNames <- fromJSON(fileArray)
  cache_key <- paste(sort(fileNames), collapse = "_")
  if (file.exists(paste0(cache_key, ".rds"))) {
    cached_result <- readRDS(paste0(cache_key, ".rds"))
    analyses <- cached_result$get_analyses()
    analysesjson <- jsonlite::serializeJSON(analyses)
    overview <- cached_result$get_overview()
    analyses_number <- cached_result$get_number_analyses()
    plot <- cached_result$plot_tic()
    plotjson <- plotly_json(plot, jsonedit = FALSE, pretty = TRUE)
    result <- list(
      overview = overview,
      analyses_number = analyses_number,
      analysesjson = analysesjson,
      plotjson = plotjson
    )
    return(result)
  } else {
    result <- list(
      error = "File not found!",
    )
 return(result)}}


#* Applying find_features on MsData for a given file
#* @post /find_features
function(req) {
  fileArray <- req$postBody
  fileNames <- fromJSON(fileArray)
  algorithm <- fileNames$algorithm
  cache_key <- fileNames$fileNames
  if (file.exists(paste0(cache_key, ".rds"))) {
    cached_result <- readRDS(paste0(cache_key, ".rds"))
    settings<-get_default_ProcessingSettings(
      call = "find_features",
      algorithm = algorithm
    )
    updated_cache<-cached_result$find_features(settings)
    print("applying find features...")
    saveRDS(updated_cache, paste0(cache_key, ".rds"))
    print("updating cache...")
    return(cache_key)
  } else {
    result <- list(
      error = "File not found!",
    )
    return(result)}}

#* Applying find_features on MsData with custom parameters
#* @post /custom_find_features
function(req) {
  data <- req$postBody
  datajson <- fromJSON(data)
  params<-datajson$parameters
  cache_key<-datajson$msData
  print(cache_key)
  browser()
  settings <- list(
    call = "find_features",
    algorithm = "xcms3",
    parameters = xcms::CentWaveParam(
      ppm = as.numeric(params$ppm),
      peakwidth = c(5, 40),
      snthresh = as.numeric(params$snthresh),
      prefilter = c(5, 1500),
      mzCenterFun = as.character(params$mzCenterFun)),
      integrate = as.numeric(params$integrate),
      mzdiff = as.numeric(params$mzdiff),
      fitgauss = as.character(params$fitgauss),
      noise = as.numeric(params$noise,
      verboseColumns = as.logical(params$verboseColumns),
      roiList = list(),
      firstBaselineCheck = as.logical(params$firstBaselineCheck),
      roiScales = numeric(),
      extendLengthMSW = as.logical(params$extendLengthMSW)
    ))
  print(settings)
  if (file.exists(paste0(cache_key, ".rds"))) {
    cached_result <- readRDS(paste0(cache_key, ".rds"))
    updated_cache<-cached_result$find_features(settings)
    print("applying find features...")
    saveRDS(updated_cache, paste0(cache_key, ".rds"))
    print("updating cache...")
    return(cache_key)
  } else {
    result <- list(
      error = "File not found!",
    )
return(result)}}


#* Applying group_features on MsData for a given file
#* @post /group_features
function(req) {
  fileArray <- req$postBody
  fileNames <- fromJSON(fileArray)
  cache_key <- paste(sort(fileNames), collapse = "_")
  if (file.exists(paste0(cache_key, ".rds"))) {
    cached_result <- readRDS(paste0(cache_key, ".rds"))
    gfs<-get_default_ProcessingSettings(
      call = "group_features",
      algorithm = "peakdensity"
    )
    updated_cache<-cached_result$group_features(gfs)
    print(updated_cache)
    print("grouping features...")
    saveRDS(updated_cache, paste0(cache_key, ".rds"))
    print("updating cache...")
    return(cache_key)
  } else {
    result <- list(
      error = "File not found!"
    )
    return(result)}}

