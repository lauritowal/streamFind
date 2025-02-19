
# resources --------------------------------------------------------------------

all_files <- streamFindData::msFilePaths()
db <- streamFindData::msSpikedChemicals()
files_mrm <- all_files[grepl("mrm", all_files)]
files <- all_files[1:3]
files1 <- all_files[grepl("influent|blank", all_files)]
files2 <- all_files[grepl("o3sw", all_files)]
db_cols <- c("name", "mass", "rt")

carbamazepin_d10 <- db[db$name %in% "Carbamazepin-d10", db_cols, with = FALSE]
diuron_d6 <- db[db$name %in% "Diuron-d6", db_cols, with = FALSE]
carb_pos <- carbamazepin_d10$mass + 1.007276
carb <- carbamazepin_d10$mass
carb_rt <- carbamazepin_d10$rt
diu_pos <- diuron_d6$mass + 1.007276
diu <- diuron_d6$mass
diu_rt <- diuron_d6$rt

sec_dev <- 30
ppm_dev <- 10

targets <- make_ms_targets(
  mz = data.frame(
    id = c("tg1", "tg2"),
    mz = c(carb_pos, diu_pos),
    rt = c(carb_rt, diu_rt)
  ),
  ppm = ppm_dev,
  sec = sec_dev
)

neutral_targets <- make_ms_targets(
  mz = data.frame(
    id = c("tg1", "tg2"),
    mz = c(carb, diu),
    rt = c(carb_rt, diu_rt)
  ),
  ppm = ppm_dev,
  sec = sec_dev
)

# settings ---------------------------------------------------------------------

settings_ff <- list(
  call = "find_features",
  algorithm = "xcms3",
  parameters = list(xcms::CentWaveParam(
    ppm = 12, peakwidth = c(5, 30),
    snthresh = 10, prefilter = c(5, 1500),
    mzCenterFun = "wMean", integrate = 1,
    mzdiff = -0.0005, fitgauss = TRUE,
    noise = 500, verboseColumns = TRUE,
    firstBaselineCheck = TRUE,
    extendLengthMSW = FALSE
  ))
)

settings_gf <- list(
  "call" = "group_features",
  "algorithm" = "xcms3",
  "parameters" = list(
    # rtalign = FALSE,
    groupParam = xcms::PeakDensityParam(
      sampleGroups = "holder",
      bw = 5,
      minFraction = 0.5,
      minSamples = 1,
      binSize = 0.008,
      maxFeatures = 100
    )
  )
)

settingsLoadFeaturesMS1 <- list(
  "call" = "load_features_ms1",
  "algorithm" = "streamFind",
  "parameters" = list(
    rtWindow = c(-2, 2),
    mzWindow = c(-1, 6),
    mzClust = 0.003,
    minIntensity = 250,
    filtered = FALSE,
    runParallel = TRUE,
    verbose = FALSE
  )
)

settingsLoadFeaturesMS2 <- list(
  "call" = "load_features_ms2",
  "algorithm" = "streamFind",
  "parameters" = list(
    isolationWindow = 1.3,
    mzClust = 0.003,
    minIntensity = 0,
    filtered = FALSE,
    runParallel = TRUE,
    verbose = FALSE
  )
)

settingsLoadGroupsMS1 <- list(
  "call" = "load_groups_ms1",
  "algorithm" = "streamFind",
  "parameters" = list(
    mzClust = 0.003,
    minIntensity = 1000,
    verbose = FALSE,
    filtered = FALSE,
    runParallel = TRUE
  )
)

settingsLoadGroupsMS2 <- list(
  "call" = "load_groups_ms2",
  "algorithm" = "streamFind",
  "parameters" = list(
    mzClust = 0.003,
    minIntensity = 250,
    filtered = FALSE,
    runParallel = TRUE,
    verbose = FALSE
  )
)

# r6 test ----------------------------------------------------------------------

# patRoon::clearCache("parsed_ms_analyses")
# patRoon::clearCache("parsed_ms_spectra")
# patRoon::clearCache("load_features_ms1")
# patRoon::clearCache("load_features_ms2")
# patRoon::clearCache("load_groups_ms1")
# patRoon::clearCache("load_groups_ms2")


ms <- MassSpecData$new(files = all_files[10:21],
  headers = list(name = "Example 1"),
  settings = list(
    find = settings_ff,
    group = settings_gf,
    ms1ft = settingsLoadFeaturesMS1,
    ms2ft = settingsLoadFeaturesMS2,
    ms1gp = settingsLoadGroupsMS1,
    ms2gp = settingsLoadGroupsMS2
  )
)

ana <- ms$get_analyses(1)
ana1 <- parse.MassSpecAnalysis(all_files[10])
all.equal(ana, ana1)

ms1 <- ms$subset_analyses(4)
ms1$load_spectra()

spec <- ms1$get_spectra()
spec <- spec[spec$level == 1, ]
write.csv(spec, "./ms_spectra.csv")

ms1$find_features()
feat <- ms1$get_features()
write.csv(feat, "./ms_features.csv")

ps <- as.ProcessingSettings(settings_ff)

asJSON(ps)

jsonlite::toJSON(Headers(name = "Example", description = "test"))



ms$get_settings("find_features")

ms$plot_spectra(analyses = 1, mz = 239, ppm = 500)

ms1 <- ms1$subset_analyses(1)

ms1$load_spectra()

ms1$get_analyses()[[1]][["spectra"]]


# do.call(ms[["get_analysis_names"]], list(analyses = 4:6))




# temp -------------------------------------------------------------------------


input <- c(1.1, 2.1, 3.31641646564465464, 1000, 314)
rcpp_parse_xml(input)







ms <- MassSpecData$new()
ms$get_headers()



ms$get_number_analyses()





# tests ------------------------------------------------------------------------

all_files <- streamFindData::msFilePaths()
big_file_test <- "E:\\Dev_20230126_IonMobilityDataFirstTraining\\WorklistData-0001.mzML"
big_file_test <- "E:\\20230126_DA_EDA_background_evaluation\\221118_DA-EDA_solid phase background_centrifuged\\mzml\\02_QC_pos-r001.mzML"
big_file_test <- all_files[8]

## headers
init <- Sys.time()
msz <- mzR::openMSfile(big_file_test)
msz3 <- mzR::header(msz)
mzR::close(msz)
Sys.time() - init

init <- Sys.time()
ana <- rcpp_parse_msAnalysis(big_file_test)
Sys.time() - init

init <- Sys.time()
ana_withR <- parse_msAnalysis(big_file_test)
Sys.time() - init



## spectra (list)
init <- Sys.time()
msz <- mzR::openMSfile(big_file_test)
msz4 <- mzR::peaks(msz)
mzR::close(msz)
Sys.time() - init

init <- Sys.time()
spectra <- rcpp_parse_spectra(big_file_test)
Sys.time() - init

analysis <- rcpp_parse_msAnalysis(big_file_test)
init <- Sys.time()
spectra_analysis <- rcpp_parse_msAnalysis_spectra(analysis)
Sys.time() - init


## create msAnalysis
ana_mzml_neg <- rcpp_parse_msAnalysis(all_files[11])
validate_msAnalysis(ana_mzml_neg)
ana_mzml_mrm_neg <- rcpp_parse_msAnalysis(all_files[28])
validate_msAnalysis(ana_mzml_mrm_neg)
ana_mzxml_pos <- rcpp_parse_msAnalysis(all_files[4])
validate_msAnalysis(ana_mzxml_pos)
ana_mzml_prof_pos <- rcpp_parse_msAnalysis(all_files[7])
validate_msAnalysis(ana_mzml_prof_pos)
ana_mzml_orb_pos <- rcpp_parse_msAnalysis(all_files[31])
validate_msAnalysis(ana_mzml_orb_pos)
ana_mzxml_orb_pos <- rcpp_parse_msAnalysis(all_files[32])
validate_msAnalysis(ana_mzxml_orb_pos)

is.data.table(rcpp_parse_msAnalysis_spectra(ana_mzml_neg))
is.data.table(rcpp_parse_msAnalysis_spectra(ana_mzml_mrm_neg)) # empty for mrm without spectra
is.data.table(rcpp_parse_msAnalysis_spectra(ana_mzxml_pos))
is.data.table(rcpp_parse_msAnalysis_spectra(ana_mzml_prof_pos))
is.data.table(rcpp_parse_msAnalysis_spectra(ana_mzml_orb_pos))
is.data.table(rcpp_parse_msAnalysis_spectra(ana_mzxml_orb_pos))

is.data.table(rcpp_parse_spectra_headers(all_files[1])) # mzML MS/MS

is.data.table(rcpp_parse_chromatograms_headers(all_files[1])) # mzML MS/MS empty for XML without chromatograms
is.data.table(rcpp_parse_chromatograms_headers(all_files[28])) # mzML SRM
is.data.table(rcpp_parse_chromatograms_headers(all_files[4])) # mzXML empty for XML without chromatograms

ms_chrom <- MassSpecData$new(files = all_files[29])

unique(ms_chrom$get_chromatograms(index = c(1, 2))$index)
unique(ms_chrom$get_chromatograms()$index)

ms_chrom$has_loaded_chromatograms()
ms_chrom$load_chromatograms()

all_files <- streamFindData::msFilePaths()

rcpp_parse_spectra(all_files[1], index = c(1, 2))
rcpp_parse_spectra(all_files[1], index = c(2, 1))

length(rcpp_parse_spectra(all_files[1]))

ana <- rcpp_parse_msAnalysis(all_files[1])
rcpp_parse_msAnalysis_spectra(ana, index = c(1, 2))
rcpp_parse_msAnalysis_spectra(ana, index = c(2, 1))

nrow(rcpp_parse_msAnalysis_spectra(ana))

rcpp_parse_chromatograms_headers(all_files[29])

View(rcpp_parse_chromatograms(all_files[29], index = c(1, 2)))
View(rcpp_parse_chromatograms(all_files[29], index = c(2, 1)))

ana <- rcpp_parse_msAnalysis(all_files[29])
rcpp_parse_msAnalysis_chromatograms(ana, index = c(1, 2))
rcpp_parse_msAnalysis_chromatograms(ana, index = c(2, 1))

nrow(rcpp_parse_msAnalysis_chromatograms(ana))














