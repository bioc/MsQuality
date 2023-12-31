% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_Spectra_metrics.R
\name{numberSpectra}
\alias{numberSpectra}
\title{number of MS1 spectra (MS:4000059) or number of MS2 spectra 
(MS:4000060)}
\usage{
numberSpectra(spectra, msLevel = 1L, ...)
}
\arguments{
\item{spectra}{\code{Spectra} object}

\item{msLevel}{\code{integer}}

\item{...}{not used here}
}
\value{
\code{numeric(1)}
}
\description{
MS:4000059 \cr
"The number of MS1 events in the run." [PSI:MS] \cr

MS:4000060 \cr
"The number of MS2 events in the run." [PSI:MS] \cr

For *MS:4000059*, \code{msLevel} is set to 1. For *MS:4000060*, 
\code{msLevel} is set to 2.

The metric is calculated as follows: \cr
(1) the \code{Spectra} object is filtered according to the MS level, \cr
(2) the number of the spectra are obtained (\code{length} of \code{Spectra})
and returned.
}
\details{
MS:4000059 \cr
synonym: "MS1-Count" EXACT [PMID:24494671] \cr
is_a: MS:4000003 ! single value \cr
relationship: has_metric_category MS:4000009 ! ID free metric \cr
relationship: has_metric_category MS:4000012 ! single run based metric \cr
relationship: has_metric_category MS:4000021 ! MS1 metric \cr
relationship: has_value_type xsd:int ! The allowed value-type for this CV term \cr
relationship: has_units UO:0000189 ! count unit \cr

MS:4000060 \cr
synonym: "MS2-Count" EXACT [PMID:24494671] \cr
is_a: MS:4000003 ! single value \cr
relationship: has_metric_category MS:4000009 ! ID free metric \cr
relationship: has_metric_category MS:4000012 ! single run based metric \cr
relationship: has_metric_category MS:4000022 ! MS2 metric \cr
relationship: has_value_type xsd:int ! The allowed value-type for this CV term \cr
relationship: has_units UO:0000189 ! count unit \cr

An attribute containing the PSI:MS term will only be returned if 
\code{msLevel} is either 1 or 2.
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
sps <- Spectra(spd)
numberSpectra(spectra = sps, msLevel = 1L)
numberSpectra(spectra = sps, msLevel = 2L)
}
\author{
Thomas Naake
}
