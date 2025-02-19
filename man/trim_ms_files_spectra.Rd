% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fct_ms_001_convert_trim_files_.R
\name{trim_ms_files_spectra}
\alias{trim_ms_files_spectra}
\title{Function to trim spectra in \emph{mzML} or \emph{mzXML} files}
\usage{
trim_ms_files_spectra(
  files,
  MS1 = TRUE,
  MS2 = TRUE,
  rtWindow = NULL,
  mzWindow = NULL,
  mzWindow_ms2 = NULL,
  intensityThreshold = NULL,
  copyMetadata = TRUE,
  path = NULL,
  prefix = "trim_"
)
}
\arguments{
\item{files}{A character vector with the full path of the file/s to trim.}

\item{MS1}{Set to TRUE for trimming MS level 1 data.}

\item{MS2}{Set to TRUE for trimming MS level 2 data.}

\item{rtWindow}{A numeric vector of length 2 with the minimum and maximum
time range to trim the files, in seconds.}

\item{mzWindow}{A numeric vector of length 2 with the minimum and maximum
\emph{m/z} range to trim the files, in Da.}

\item{mzWindow_ms2}{A numeric vector of length 2 with the minimum and maximum
\emph{m/z} range to trim MS2 data files, in Da. when NULL and MS2 is TRUE
the \code{mzWindow} argument is used instead.}

\item{intensityThreshold}{A numeric vector of length one with the minimum
intensity threshold. Traces below the given intensity threshold are removed.
If a length two vector is given, the first value if applied for MS1 data
and the second to MS2 data.}

\item{copyMetadata}{Set to TRUE to copy metadata from the original file.}

\item{path}{A character string with the path to save the files.
When \code{NULL}, the file directory is used instead.}

\item{prefix}{A character string with the name prefix for the new
trimmed file.}
}
\value{
Saves the trimmed \emph{mzML} or \emph{mzXML} files
in a given path, adding a pre-defined prefix to the file name.
}
\description{
Trim spectra in \emph{mzML} or \emph{mzXML} files based on time
(in seconds) and  \emph{m/z} (in Da) ranges, using the \pkg{mzR} package.
}
\note{
When giving paths make sure that single backslash is changed to
double backslash of to single forward slash.
}
\references{
\insertRef{mzr01}{streamFind}

\insertRef{mzr02}{streamFind}

\insertRef{mzr03}{streamFind}

\insertRef{mzr04}{streamFind}
}
