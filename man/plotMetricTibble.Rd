% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_visualizations.R
\name{plotMetricTibble}
\alias{plotMetricTibble}
\title{Helper function for plotMetric}
\usage{
plotMetricTibble(qc, metric)
}
\arguments{
\item{qc}{\code{data.frame}}

\item{metric}{\code{character}}
}
\value{
\code{tibble}
}
\description{
The function \code{plotMetricTibble} is a helper function for the function
\code{plotMetric}. It returns a tibble in long format that is interpretable
by \code{ggplot2}.
}
\details{
\code{plotMetricRibble} will select all columns that start with
\code{metric}. The different levels in the \code{name} column in the returned 
tibble correspond to the columns that were selected and do not contain the
\code{metric} prefix. In case there is no additional specification 
(e.g. for the metric \code{chromatographyDuration} only the column 
\code{chromatographyDuration} will 
be selected), the \code{name} column will include the \code{metric} 
(\code{chromatographyDuration}).
}
\examples{
library(msdata)
library(MsExperiment)
library(S4Vectors)
msexp <- MsExperiment()
sd <- DataFrame(sample_id = c("QC1", "QC2"),
    sample_name = c("QC Pool", "QC Pool"), injection_idx = c(1, 3))
sampleData(msexp) <- sd

## define file names containing spectra data for the samples and
## add them, along with other arbitrary files to the experiment
fls <- dir(system.file("sciex", package = "msdata"), full.names = TRUE)
experimentFiles(msexp) <- MsExperimentFiles(
    mzML_files = fls,
    annotations = "internal_standards.txt")
## link samples to data files: first sample to first file in "mzML_files",
## second sample to second file in "mzML_files"
msexp <- linkSampleData(msexp, with = "experimentFiles.mzML_files",
    sampleIndex = c(1, 2), withIndex = c(1, 2))
msexp <- linkSampleData(msexp, with = "experimentFiles.annotations",
    sampleIndex = c(1, 2), withIndex = c(1, 1))

library(Spectra)
## import the data and add it to the mse object
spectra(msexp) <- Spectra(fls, backend = MsBackendMzR())

## define the quality metrics to be calculated
metrics <- c("areaUnderTic", "chromatographyDuration", "msSignal10xChange")

## calculate the metrics
## additional parameters passed to the quality metrics functions
## (msLevel is an argument of areaUnderTic and msSignal10xChange,
## relativeTo is an argument of msSignal10xChange)
qc <- calculateMetricsFromMsExperiment(msexp = msexp, metrics = metrics, 
    msLevel = 1, relativeTo = "Q1", change = "jump")
rownames(qc) <- c("Sample 1", "Sample 2")
plotMetricTibble(qc, metric = "areaUnderTic")
}
\author{
Thomas Naake, \email{thomasnaake@googlemail.com}
}
