
### settings ------------------------------------------------------------------

#' @title settings
#'
#' @description An S4 class object with settings for a given
#'   data processing step of the basic workflow in \pkg{streamFind}.
#'   The \code{settings} object contains the algorithm to be used for
#'   a given processing step and the list of respective parameter settings.
#'
#' @slot call The name of the function where the algorithm and parameters are used.
#' @slot algorithm A character string with the name of the algorithm to be used.
#' @slot parameters A list of parameters dependent on the algorithm used.
#'
#' @export
#'
#' @md
setClass("settings",
  slots = c(
    call = "character",
    algorithm = "character",
    parameters = "list"
  ),
  prototype = list(
    call = NA_character_,
    algorithm = NA_character_,
    parameters = list()
  )
)

### settings-methods ----------------------------------------------------------

#### getCall ------------------------------------------------------------------

#' @describeIn settings getter for function call.
#'
#' @param x A \linkS4class{settings} object.
#'
#' @export
#'
#' @importFrom stats getCall
#'
setMethod("getCall", "settings", function(x) {

  return(x@call)
})



#### getAlgorithm -------------------------------------------------------------

#' @describeIn settings getter for algorithm.
#'
#' @param object A \linkS4class{settings} object.
#'
#' @export
#'
setMethod("getAlgorithm", "settings", function(object) {

  return(object@algorithm)
})

#### getParameters ------------------------------------------------------------

#' @describeIn settings getter for parameters.
#'
#' @export
#'
setMethod("getParameters", "settings", function(object) {

  return(object@parameters)
})



#### exportSettings -----------------------------------------------------------

#' @describeIn settings exports the settings as either JSON or rds.
#'
#' @param name A character string with the file name.
#' @param format A character string with the format ("rds" (default) or "json").
#' @param path The directory path to save the file.
#'
#' @export
#'
#' @importFrom jsonlite toJSON
#'
setMethod("exportSettings", "settings", function(object,
                                                 name = "settings",
                                                 format = "rds",
                                                 path = getwd()) {

  if (format %in% "rds") {
    saveRDS(object, file = paste0(path, "/" ,name, ".", format))
  }

  if (format %in% "json") {
    object_list <- list(
      call = object@call,
      algorithm = object@algorithm,
      parameters = object@parameters
    )

    object_list <- toJSON(object_list,
      force = TRUE, auto_unbox = TRUE, pretty = TRUE
    )

    write(object_list, file = paste0(path, "/" ,name, ".", format))
  }

})


### functions -----------------------------------------------------------------

#' createSettings
#'
#' @description Creates a \linkS4class{settings} object for a given processing step.
#'
#' @param call The name of the function where the algorithm and settings are used.
#' @param algorithm A character string with the name of the algorithm to be used.
#' @param parameters A list of parameters dependent on the algorithm used.
#'
#' @return A \linkS4class{settings} object.
#'
#' @export
#'
createSettings <- function(call = NA_character_, algorithm = NA_character_, parameters = list()) {

  ns <- new("settings")

  ns@call <- call
  ns@algorithm <- algorithm

  if (!checkmate::testClass(parameters, "list")) parameters <- list(parameters)

  ns@parameters <- parameters

  return(ns)

}



#' @title importSettings
#'
#' @description Imports settings as either JSON or rds.
#'
#' @param file A character string with the full file path.
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom tools file_ext
#'
importSettings <- function(file) {

  if (file_ext(file) %in% "json") {
    object_list <- fromJSON(file)

    #check if parameters entries are data.frame
    if (is.data.frame(object_list$parameters)) {
      object_list$parameters <- list(object_list$parameters)
    }

    object_list$parameters <- lapply(object_list$parameters, function(x) {

      if (is.data.frame(x)) {
        x_t <- as.list(x)
        calss_to_use <- x_t$class
        x_t["Class"] <- x_t$class
        x_t["class"] <- NULL
        x_t <- lapply(x_t, function(z) {
          if (is.list(z)) {
            return(z[[1]])
          } else {
            return(z)
          }
        })

        # to fix when converting to json (the problem is the NULL entries are returned as list by default)
        if (x_t$Class %in% "CentWaveParam") x_t$roiScales <- as.double()

        return(do.call("new", x_t))

      } else {
        return(x)
      }
    })

    return(
      createSettings(
        call = object_list$call,
        algorithm = object_list$algorithm,
        parameters = object_list$parameters
      )
    )
  }

  if (file_ext(file) %in% "rds") {
    return(readRDS(file))
  }
}
