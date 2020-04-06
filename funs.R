# Tue Feb 11 21:15:22 2020 ------------------------------
library(abind)
library(tuneR)
library(parallel)

# read, downsample, clip, mel spec, normalize and remove noise
melspec <- function(x, start, end){
        mp3 <- readMP3(filename = x) %>% 
                extractWave(xunit = "time",
                            from = start, to = end)
        
        # return log-spectrogram with 256 Mel bands and compression
        sp <- melfcc(mp3, nbands = 256, usecmp = T,
                     spec_out = T,
                     hoptime = (end-start) / 256)$aspectrum
        
        # Median-based noise reduction
        noise <- apply(sp, 1, median)
        sp <- sweep(sp, 1, noise)
        sp[sp < 0] <- 0
        
        # Normalize to max
        sp <- sp / max(sp)
        
        return(sp)
}

# iterate melspec over all samples, arrange output into array
melslice <- function(x, from, to){
        lapply(X = x, FUN = melspec,
               start = from, end = to) %>%
                simplify2array()
}

# iterate melslice over all different time windows
audioProcess <- function(files, limit = 10, ws = 10, stride = 2,
                         ncores = 8){
        windowSize <- seq(0, limit, by = stride)
        # iterate and parallelise
        batches <- mclapply(windowSize, function(w){
                # execute
                melslice(files, from = w, to = w+ws)
        }, mc.cores = ncores)
        # combine output into single array
        out <- abind(batches, along = 3)
        # reorder dimensions after adding single-channel as 4th
        dim(out) <- c(dim(out), 1)
        out <- aperm(out, c(3,1,2,4))
        return(out)
}
