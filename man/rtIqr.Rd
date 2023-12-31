% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_Spectra_metrics.R
\name{rtIqr}
\alias{rtIqr}
\title{interquartile RT period for identified quantification data points
(MS:4000153)}
\usage{
rtIqr(
  spectra,
  msLevel = 1L,
  identificationLevel = c("all", "identified", "unidentified"),
  ...
)
}
\arguments{
\item{spectra}{\code{Spectra} object}

\item{msLevel}{\code{integer}}

\item{identificationLevel}{\code{character(1)}, one of \code{"all"}, 
\code{"identified"}, or \code{"unidentified"}}

\item{...}{not used here}
}
\value{
\code{numeric(1)}
}
\description{
MS:4000153 \cr
"The interquartile retention time period, in seconds, for all quantification 
data points after user-defined acceptance criteria are applied over the 
complete run. Longer times indicate better chromatographic separation. 
These data points may be for example XIC profiles, isotopic pattern areas, 
or reporter ions (see MS:1001805). The used type should be noted in the 
metadata or analysis methods section of the recording file for the respective 
run. In case of multiple acceptance criteria (FDR) available in proteomics, 
PSM-level FDR should be used for better comparability." [PSI:MS] \cr

The metric is calculated as follows: \cr
(1) the \code{Spectra} object is filtered according to the MS level, \cr
(2) the retention time values are obtained, \cr
(3) the interquartile range is obtained from the values and returned
(\code{NA} values are removed). \cr
}
\details{
MS:4000153 \cr
is_a: MS:4000003 ! single value \cr
is_a: MS:4000008 ! ID based \cr
is_a: MS:4000017 ! chromatogram metric \cr
relationship: has_units UO:0000010 ! second \cr
synonym: "C-2A"  RELATED [PMID:19837981] \cr

Retention time values that are \code{NA} are removed.

An attribute containing the PSI:MS term will only be returned if 
\code{identificationLevel} is \code{"identified"}.
}
\note{
The \code{Spectra} object might contain features that were not identified. If
the calculation needs to be done according to *MS:4000153*, the 
\code{Spectra} object should be prepared accordingly, i.e. subsetted to 
\code{spectra} with identification data.

The stored retention time information in \code{spectra} might have a 
different unit than seconds. \code{rtIqr} will return the IQR based on the 
values stored in \code{spectra} and will not convert these values to seconds.
}
\examples{
library(S4Vectors)
library(Spectra)

spd <- DataFrame(
    msLevel = c(2L, 2L, 2L),
    polarity = c(1L, 1L, 1L),
    id = c("HMDB0000001", "HMDB0000001", "HMDB0001847"),
    name = c("1-Methylhistidine", "1-Methylhistidine", "Caffeine"))
## Assign m/z and intensity values
spd$mz <- list(
    c(109.2, 124.2, 124.5, 170.16, 170.52),
    c(83.1, 96.12, 97.14, 109.14, 124.08, 125.1, 170.16),
    c(56.0494, 69.0447, 83.0603, 109.0395, 110.0712,
        111.0551, 123.0429, 138.0662, 195.0876))
spd$intensity <- list(
    c(3.407, 47.494, 3.094, 100.0, 13.240),
    c(6.685, 4.381, 3.022, 16.708, 100.0, 4.565, 40.643),
    c(0.459, 2.585, 2.446, 0.508, 8.968, 0.524, 0.974, 100.0, 40.994))
spd$rtime <- c(9.44, 9.44, 15.84)
sps <- Spectra(spd)
rtIqr(spectra = sps, msLevel = 2L)
}
\author{
Thomas Naake
}
