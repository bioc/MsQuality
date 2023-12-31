## First, we will load the information on the metabolite levels and the
## associated metadata (information on molecular weight, retention time,
## etc.).
data("Lee_2019_meta_vals", package = "MsQuality")

## We will create per sample one `Spectra` object. The data set of
## Lee et al. (2019) contains samples in columns and the feature-extracted
## information on metabolites in the rows.
## We will create separate lists of `Spectra` objects for the RPLC- and
## HILIC-derived levels.
## filter for RPLC
vals_rplc <- vals[grep(vals$Metabolite, pattern = "_rp$"), ]
meta_rplc <- meta[grep(meta$Method, pattern = "RPLC-"), ]

## to link the meta data with the data frame containing the intensity values,
## harmonise the names of the metabolites
names_vals_rplc <- tolower(make.names(vals_rplc$Metabolite))
names_vals_rplc <- stringr::str_remove(names_vals_rplc, "_rp$")
vals_rplc$Metabolite <- gsub(names_vals_rplc, pattern = "[.]",
    replacement = "_")
## harmonise the metabolite names of the meta data
names_meta_rplc <- tolower(make.names(meta_rplc$Standard.Compound))
meta_rplc$Standard.Compound <- gsub(names_meta_rplc, pattern = "[.]",
    replacement = "_")

## add the meta data to the data frame containing the intensity values
library("dplyr")
rplc <- inner_join(meta_rplc, vals_rplc,
    by = c("Standard.Compound" = "Metabolite"))
    
## how many metabolites are remaining after intersecting the metabolite names
dim(rplc)

## Do the same data wrangling steps for the HILIC-derived intensity values.
## filter for HILIC
vals_hilic <- vals[grep(vals$Metabolite, pattern = "_hn$"), ]
meta_hilic <- meta[grep(meta$Method, pattern = "HILIC-"), ]

## to link the meta data with the data frame containing the intensity values,
## harmonise the names of the metabolites
names_vals_hilic <- tolower(make.names(vals_hilic$Metabolite))
names_vals_hilic <- stringr::str_remove(names_vals_hilic, "_hn$")
vals_hilic$Metabolite <- gsub(names_vals_hilic, pattern = "[.]",
    replacement = "_")

## harmonise the metabolite names of the meta data
names_meta_hilic <- tolower(make.names(meta_hilic$Standard.Compound))
meta_hilic$Standard.Compound <- gsub(names_meta_hilic, pattern = "[.]",
    replacement = "_")
    
## add the meta data to the data frame containing the intensity values
hilic <- inner_join(meta_hilic, vals_hilic,
    by = c("Standard.Compound" = "Metabolite"))

## how many metabolites are remaining after intersecting the metabolite names
dim(hilic)

## We then create for the LC-separated features a list of `Spectra` objects. 
## Since the `rplc` and `hilic` objects have the same structure, we will 
## define a helper function that we apply on these objects to create the 
## list. 
create_Spectra <- function(data) {
    sps_l <- list()
    begin <- which(colnames(data) == "Sample.1")
    end <- which(colnames(data) == "Sample.638")
    
    for (i in begin:end) {
        data_i <- data[!is.na(data[, i]), ]
        int_i <- data_i[, i]
        if (length(int_i) > 0) {
            spd <- DataFrame(
                msLevel = c(rep(1L, length(int_i))),
                polarity = c(rep(1L, length(int_i))),
                id = data_i[, "CAS.Number"],
                name = data_i[, "Standard.Compound"])
            spd$mz <- lapply(seq_len(length(int_i)),
                function(x) as.vector(data_i[x, "Precursor.Ion..g.mol."]))
            spd$intensity <- lapply(seq_len(length(int_i)),
                function(x) as.vector(int_i[x]))
            sps <- Spectra::Spectra(spd)
            sps$rtime <- data_i[, "RT..min."]
            sps$precursorIntensity <- as.vector(int_i)
            
            ## use the molecular weight as a proxy for precursor m/z 
            sps$precursorMz <- data_i[, "Precursor.Ion..g.mol."]
            sps$dataOrigin <- colnames(data)[i]
        } else {
            sps <- NA
        }
        sps_l[[i - 9]] <- sps
        names(sps_l)[i - 9] <- colnames(data)[i]
    }
    return(sps_l)
}
## apply the function on the RPLC- and HILIC-derived intensity values 
sps_l_rplc <- create_Spectra(data = rplc)
sps_l_hilic <- create_Spectra(data = hilic)

## show the first list entries of sps_l_rplc and sps_l_hilic
sps_l_rplc[[1]]
sps_l_hilic[[1]]

## Some of the samples only contained missing values for the probed 
## metabolites. In the following the paired samples are removed from the 
## list of `Spectra` objects if one of the samples only contains missing 
## values (the respective list entry contains NA). 
inds_remove <- lapply(seq_along(sps_l_rplc),
    function(x) !is(
        sps_l_rplc[[x]], "Spectra") | !is(sps_l_hilic[[x]], "Spectra"))
inds_remove <- unlist(inds_remove)
## print the number of removed entries
table(inds_remove)
sps_l_rplc <- sps_l_rplc[!inds_remove]
sps_l_hilic <- sps_l_hilic[!inds_remove]

## The functions in `MsQuality` might also accept a collection of `Spectra` 
## objects stored in an `MsExperiment`. We will convert the list of 
## `Spectra` objects to an `MsExperiment` object.

## create the final Spectra objects, add information on the origin 
## (RPLC, HILIC) of the spectra
sps_rplc <- Reduce(c, sps_l_rplc)
sps_hilic <- Reduce(c, sps_l_hilic)
sps_rplc$dataOrigin <- paste0(sps_rplc$dataOrigin, "_RPLC")
sps_hilic$dataOrigin <- paste0(sps_hilic$dataOrigin, "_HILIC")

## create an empty MsExperiment object and fill it with data
msexp_rplc <- msexp_hilic <- MsExperiment()
sampleData(msexp_rplc) <- DataFrame(
    samples = paste0(names(sps_l_rplc), "_RPLC"))
sampleData(msexp_hilic) <- DataFrame(
    samples = paste0(names(sps_l_hilic), "_HILIC"))
rownames(sampleData(msexp_rplc)) <- names(sps_l_rplc)
rownames(sampleData(msexp_hilic)) <- names(sps_l_hilic)
spectra(msexp_rplc) <- sps_rplc
spectra(msexp_hilic) <- sps_hilic

## link the spectra to the samples
msexp_rplc <- linkSampleData(object = msexp_rplc,
    with = "sampleData.samples = spectra.dataOrigin")
msexp_hilic <- linkSampleData(object = msexp_hilic,
    with = "sampleData.samples = spectra.dataOrigin")

## show the msexp_rplc and msexp_hilic objects
msexp_rplc
msexp_hilic

save(sps_rplc, sps_hilic, msexp_rplc, msexp_hilic, 
    file = "Lee2019.RData", compress = "xz")
