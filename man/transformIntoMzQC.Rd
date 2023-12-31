% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_calculateMetrics_from_Spectra.R
\name{transformIntoMzQC}
\alias{transformIntoMzQC}
\title{Transform the metrics into a list of \code{MzQCmzQC} objects}
\usage{
transformIntoMzQC(spectra_metrics)
}
\arguments{
\item{spectra_metrics}{list of named vector}
}
\value{
\code{list} containing as entries \code{MzQCmzQC} objects for each
\code{Spectra} with same \code{dataOrigin}
}
\description{
The function \code{transformIntoMzQC} transfers the metrics stored in 
\code{spectra_metrics} into a list of \code{MzQCmzQC} objects. Each list 
entry will refer to the corresponding entry in \code{spectra_metrics}.
As such, each entry contains information from a single \code{dataOrigin}
of a \code{Spectra} object.

The function \code{transformIntoMzQC} is a helper function within
\code{calculateMetricsFromSpectra}.
}
\details{
The \code{MzQCmzQC} object will only contain those quality metrics
that have a corresponding attribute with a [PSI:MS] identifier. The 
matching is done via the names of each vector in \code{spectra_metrics}.

The Field \code{"version"} is set to the current version of the \code{rmzqc}
package.

The entry of \code{"MzQCanalysisSoftware"} is filled with the [PSI:MS] id
of \code{MsQuality} ("MS:") and the version is taken from
\code{packageDescription("MsQuality")[["Version"]]}.
}
\examples{
library(msdata)
library(Spectra)

## define file names containing spectra data for the samples
fls <- dir(system.file("sciex", package = "msdata"), full.names = TRUE)

## import the data and add it to the spectra object
spectra <- Spectra(fls, backend = MsBackendMzR())

## define the quality metrics to be calculated
metrics <- c("areaUnderTic", "chromatographyDuration", "msSignal10xChange")

## obtain the spectra_metrics object
f <- dataOrigin(spectra)
f_unique <- unique(f)
## spectra_metrics <- bplapply(f_unique, function(f_unique_i) {
##calculateMetricsFromOneSampleSpectra(
##    spectra = spectra[f == f_unique_i], metrics = metrics)
##    }, BPPARAM = bpparam())

## transform into mzQC objects
##transformIntoMzQC(spectra_metrics)

}
\author{
Thomas Naake, Johannes Rainer
}
