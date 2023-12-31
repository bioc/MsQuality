% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_visualizations.R
\name{plotMetric}
\alias{plotMetric}
\title{Visualize a quality metric}
\usage{
plotMetric(qc, metric = "areaUnderTic", plotly = TRUE)
}
\arguments{
\item{qc}{\code{matrix}/\code{data.frame}}

\item{metric}{\code{character}}

\item{plotly}{\code{logical(1)}}
}
\value{
\code{gg} \code{plotly}
}
\description{
The function \code{plotMetric} visualizes the metric values per sample. The 
function accepts the output of \code{calculateMetrics} or,
\code{calculateMetricsFromSpectra}, or 
\code{calculateMetricsFromMsExperiment} and a vector specifying the metric 
to display.
}
\details{
\code{plotMetric} will select all columns that start with
\code{metric}. The different levels in the \code{name} column in the 
returned tibble correspond to the columns that were selected and do not 
contain the \code{metric} prefix. In case there is no additional specification 
(e.g. for the metric \code{chromatographyDuration} only the column \code{chromatographyDuration} will 
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

library(Spectra)
## import the data and add it to the msexp object
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

## do the actual plotting
plotMetric(qc, metric = "areaUnderTic", plotly = TRUE)
}
\author{
Thomas Naake, \email{thomasnaake@googlemail.com}
}
