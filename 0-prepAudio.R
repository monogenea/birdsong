# Tue Feb  4 19:43:33 2020 ------------------------------
setwd("~/Documents/Tutorials/birdsong")
library(parallel)
library(tidyverse)
library(abind)
library(caret)
library(tuneR)
library(warbleR)
source("funs.R")

# Create mp3/ if necessary
if(!dir.exists("mp3/")){
      dir.create("mp3/")
}

#### Download HQ male song recordings > 30s long from Europe ####
query <- querxc("type:song type:male len_gt:30 q_gt:C area:europe")
query$species <- with(query, paste(Genus, Specific_epithet))
# Select top 50 most abundant bird species
speciesCount <- sort(table(query$species), decreasing = T)
topSpecies <- names(speciesCount)[1:50]
query <- query[query$species %in% topSpecies, ]
# Downsample to min size among the 50 classes
balancedClasses <- lapply(topSpecies, function(x){
   set.seed(100)
   sample(which(query$species == x), min(table(query$species)))
}) %>% unlist()
# Subset accordingly
query <- query[balancedClasses, ]
# Download using updated query
querxc(X = query, download = T, path = "mp3/", parallel = 8)

#### Pre-processing ####
# Read files
fnames <- list.files("mp3/", full.names = T, patt = "*.mp3")

# Play random file - setWavPlayer in macOS if "permission denied"
setWavPlayer('/usr/bin/afplay')
# play(sample(fnames, 1)) # esc to skip

# Encode species from fnames regex
species <- str_extract(fnames, patt = "[A-Za-z]+-[a-z]+") %>%
      gsub(patt = "-", rep = " ") %>% factor()

# Stratified sampling: train (80%), val (10%) and test (10%)
set.seed(100)
idx <- createFolds(species, k = 10)
valIdx <- idx$Fold01
testIdx <- idx$Fold02
# Define samples for train, val and test
fnamesTrain <- fnames[-c(valIdx, testIdx)]
fnamesVal <- fnames[valIdx]
fnamesTest <- fnames[testIdx]

# Take multiple readings per sample for training
Xtrain <- audioProcess(files = fnamesTrain, ncores = 5,
                       limit = 20, ws = 10, stride = 5)
Xval <- audioProcess(files = fnamesVal, ncores = 5,
                     limit = 20, ws = 10, stride = 5)
Xtest <- audioProcess(files = fnamesTest, ncores = 5,
                      limit = 20, ws = 10, stride = 5)

# Define targets and augment data
target <- model.matrix(~0+species)

targetTrain <- do.call("rbind", lapply(1:(dim(Xtrain)[1]/length(fnamesTrain)),
                                       function(x) target[-c(valIdx, testIdx),]))
targetVal <- do.call("rbind", lapply(1:(dim(Xval)[1]/length(fnamesVal)),
                                     function(x) target[valIdx,]))
targetTest <- do.call("rbind", lapply(1:(dim(Xtest)[1]/length(fnamesTest)),
                                      function(x) target[testIdx,]))
# Assemble Xs and Ys
train <- list(X = Xtrain, Y = targetTrain)
val <- list(X = Xval, Y = targetVal)
test <- list(X = Xtest, Y = targetTest)

# Plot spectrogram from random training sample - range is 1-22.05 kHz
image(train$X[sample(dim(train$X)[1], 1),,,],
      xlab = "Time (s)",
      ylab = "Frequency (kHz)",
      axes = F)
# Generate mel sequence from Hz points, standardize to plot
freqs <- seq(1, 22.05, length.out = 6)
mels <- 2595 * log10(1 + (freqs*1e3) / 700) # https://en.wikipedia.org/wiki/Mel_scale
mels <- mels - min(mels)
mels <- mels / max(mels)

axis(1, at = seq(0, 1, by = .2), labels = seq(0, 10, by = 2))
axis(2, at = mels, las = 2,
     labels = round(freqs, 1))
axis(3, labels = F); axis(4, labels = F)

#### Save ####
save(train, val, test, file = "prepAudio.RData")
