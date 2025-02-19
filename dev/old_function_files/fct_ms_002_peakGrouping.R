
#' @title peakGrouping
#'
#' @description Grouping and alignment of peaks across samples.
#' The peak grouping uses the \pkg{patRoon} package.
#'
#' @param object A \linkS4class{msData} object with
#' \linkS4class{msAnalysis} objects containing peaks.
#' @template args-single-settings
#'
#' @note The call in the \linkS4class{settings} must be set to "peakGrouping".
#'
#' @return An \linkS4class{msData} object containing a features S4 class.
#'
#' @details The following algorithms are possible: "xcms3", "xcms", "openms".
#' See ?\pkg{patRoon} for further information.
#' See \code{\link[patRoon]{groupFeatures}} for more information.
#'
#' @seealso \code{\link[patRoon]{groupFeatures}}
#'
#' @references
#' \insertRef{patroon01}{streamFind}
#'
#' @export
#'
peakGrouping <- function(object = NULL, settings = NULL) {

  requireNamespace("patRoon")

  assertClass(object, "msData")

  noPeaks <- sapply(object@analyses, function(x) nrow(x@peaks))
  noPeaks <- TRUE %in% (0 %in% noPeaks)

  if (noPeaks) {
    warning("Object does not have peaks to group!")
    return(object)
  }

  # TODO implement as.featuresSet for multiple polarities
  pat <- as.features(object)

  if (is.null(settings)) {

    prs <- getSettings(object, where = "features", call = "peakGrouping")

    if (length(prs) > 0) {
      algorithm = getAlgorithm(prs)
      params = getParameters(prs)
    }

  } else if (testClass(settings, "settings")) {

    algorithm <- getAlgorithm(settings)
    params <- getParameters(settings)

  } else {

    algorithm <- NA_character_
  }


  if (is.na(algorithm)) {
    warning("Peak grouping algorihtm not defined!")
    return(object)
  }


  if (algorithm == "xcms3") {
      params$groupParam@sampleGroups <- replicateNames(object)
    if ("rtalign" %in% names(params)) if (params$rtalign) {
      params$preGroupParam@sampleGroups <- replicateNames(object)
    }
  }

  ag <- list(obj = pat, algorithm = algorithm)

  gr_fun <- patRoon::groupFeatures

  pat <- do.call(gr_fun, c(ag, params))

  stgs <- createSettings(call = "peaksGrouping",
    algorithm = algorithm, parameters = params)

  object <- addSettings(object, settings = stgs, where = "features")

  object <- buildPeaksTable(object, pat)

  object <- buildFeatures(object, pat)

  object <- addAdjustedRetentionTime(object, pat)

  validObject(object)

  return(object)
}



#' buildFeatures
#'
#' @param object An \linkS4class{msData} object.
#' @param pat A \linkS4class{featureGroups} object from the package \pkg{patRoon}
#'
#' @return An \linkS4class{msData} object with updated features slot.
#'
buildFeatures <- function(object, pat) {

  cat("Building table with features... ")

  feat <- patRoon::as.data.table(pat, average = FALSE)
  feat[, `:=`(ret = NULL, mz = NULL)]

  mtd <- patRoon::as.data.table(pat, average = TRUE)
  setnames(mtd, "ret", "rt")
  mtd <- mtd[, .(group, mz, rt)]

  pk <- peaks(object)

  index <- lapply(mtd$group, function(x, pk) {
    return(which(pk$feature == x))
  }, pk = pk)

  mtd$dppm <- unlist(lapply(index, function(x) {
    return(round(max((pk[x, mzmax] - pk[x, mzmin]) / pk[x, mz] * 1E6),
                 digits = 1))
  }))

  mtd$drt <- unlist(lapply(index, function(x) {
    return(round(max(pk[x, rtmax] - pk[x, rtmin]), digits = 0))
  }))

  pk$replicate <- factor(pk$replicate, levels = unique(replicateNames(object)))

  tp_pks <- setNames(
    data.frame(
      matrix(ncol = length(analysisNames(object)),
             nrow = 1)), analysisNames(object)
  )

  tp_pks[1, ] <- 0

  mtd$peaks <- lapply(index, function(x, pk, tp_pks) {
    temp <- copy(tp_pks)
    temp[1, colnames(temp) %in% pk$analysis[x]] <- pk$index[x]
    return(temp)
  }, pk = pk, tp_pks = tp_pks)

  mtd$index <- as.numeric(sub(".*_", "", mtd$group))

  if ("is_filled" %in% colnames(pk)) {
    mtd$hasFilled <- unlist(lapply(index, function(x) 1 %in% pk$is_filled[x]))
  } else {
    mtd$hasFilled <- FALSE
  }

  if (!"filtered" %in% colnames(mtd)) {
    mtd$filtered <- FALSE
    mtd$filter <- NA_character_
  }

  if (grepl("Set", class(pat))) {

    set <- TRUE

    annot <- pat@annotations

    setnames(mtd, "mz", "mass")
    mtd$adduct <- feat$adduct

    new_id <- paste0(
      "m",
      round(mtd$mass, digits = 3),
      "_d",
      mtd$dppm,
      "_rt",
      round(mtd$rt, digits = 0),
      "_t",
      mtd$drt,
      "_f",
      mtd$index
    )

  } else {

    adduct <- unique(pk$adduct)

    mtd$adduct <- adduct

    if (adduct %in% "[M+H]+") {
      mtd$mass <- mtd$mz - 1.0073
    }

    if (adduct %in% "[M-H]-") {
      mtd$mass <- mtd$mz + 1.0073
    }

    new_id <- paste0(
      "mz",
      round(mtd$mz, digits = 3),
      "_d",
      mtd$dppm,
      "_rt",
      round(mtd$rt, digits = 0),
      "_t",
      mtd$drt,
      "_f",
      mtd$index
    )

  }

  new_id <- data.table(group = mtd$group , id = new_id)

  mtd <- left_join(mtd, new_id, by = "group")
  mtd[, group := NULL]

  mtd <- select(mtd, id, index, everything())

  feat <- left_join(feat, new_id, by = "group")
  feat[, group := NULL]
  if ("neutralMass" %in% colnames(feat)) feat[, neutralMass := NULL]
  if ("adduct" %in% colnames(feat)) feat[, adduct := NULL]
  feat <- select(feat, id, everything())


  #updates feature id in peaks table of each analysis
  setnames(new_id, c("group", "id"), c("feature", "new_feature"))
  object@analyses <- lapply(object@analyses, function(x, new_id) {
    x@peaks <- left_join(x@peaks, new_id, by = "feature")
    x@peaks[, feature := NULL]
    setnames(x@peaks, "new_feature", "feature")
    return(x)
  }, new_id = new_id)


  object@features@intensity <- feat
  object@features@metadata <- mtd

  cat("Done! \n")

  return(object)
}



#' @title addAdjustedRetentionTime
#'
#' @description Function to add adjusted retention time information
#' to the spectra slot of each \linkS4class{msAnalysis} in the
#' \linkS4class{msData} object.
#'
#' @param object An \linkS4class{msData} object.
#' @param pat A \linkS4class{featureGroups} object from \pkg{patRoon}.
#'
addAdjustedRetentionTime <- function(object, pat) {

  assertClass(object, "msData")

  if (testClass(pat, "featureGroupsXCMS3")) {

    if (xcms::hasAdjustedRtime(pat@xdata)) {

      cat("Adding adjusted retention time values... ")

      rtAdj <- xcms::adjustedRtime(pat@xdata)

      pkAdj <- xcms::processHistory(
        pat@xdata,
        type = "Retention time correction"
      )[[1]]
      pkAdj <- pkAdj@param

      addAdjPoints <- FALSE
      if (testClass(pkAdj, "PeakGroupsParam")) {
        addAdjPoints <- TRUE
        pkAdj <- xcms::peakGroupsMatrix(pkAdj)
      }

      hasSpectra <- sapply(object@analyses, function(x) nrow(x@spectra))
      hasSpectra <- hasSpectra > 0
      names(hasSpectra) <- analysisNames(object)

      object@analyses <- lapply(object@analyses, function(x, hasSpectra) {
        if (!hasSpectra[analysisNames(x)]) {
          x <- loadSpectraInfo(x)
        }
        return(x)
      }, hasSpectra = hasSpectra)

      object@analyses <- lapply(object@analyses,
        function(x, object, rtAdj, addAdjPoints, pkAdj, n_ana) {

        ana_idx <- which(analysisNames(object) %in% analysisNames(x))

        rts <- names(rtAdj)
        ana_idx_string <- paste0(
          "F",
          paste(rep("0", nchar(n_ana) - nchar(ana_idx)), collapse = ""),
          ana_idx
        )
        rts <- str_detect(rts, ana_idx_string)
        rts <- rtAdj[rts]

        temp <- x@spectra
        temp$rtAdjusted <- rts
        temp$adjustment <- temp$rtAdjusted - temp$rt

        if (addAdjPoints) {
          pk_rts <- unique(pkAdj[, ana_idx])
          pk_rts <- pk_rts[pk_rts %in% temp$rt]
          temp[rt %in% pk_rts, adjPoints := pk_rts]
        }

        x@spectra <- copy(temp)

        return(x)
      },
      object = object,
      rtAdj = rtAdj,
      addAdjPoints = addAdjPoints,
      pkAdj = pkAdj,
      n_ana = length(object@analyses))

      cat("Done! \n")
      return(object)
    }
  }

  return(object)
}
