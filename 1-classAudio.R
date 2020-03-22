# Fri Feb  7 15:49:46 2020 ------------------------------
setwd("~/Documents/Tutorials/birdsong")
library(keras)
use_condaenv("plaidml")
use_backend("plaidml")
k_backend() # plaidml
library(tidyverse)
library(caret)
library(e1071)
library(pheatmap)
library(RColorBrewer)

# Read processed data
load("prepAudio.RData")

# Build model
model <- keras_model_sequential() %>% 
        layer_conv_2d(input_shape = dim(train$X)[2:4], 
                      filters = 16, kernel_size = c(3, 3),
                      activation = "relu") %>% 
        layer_max_pooling_2d(pool_size = c(2, 2)) %>% 
        layer_dropout(rate = .2) %>% 
        
        layer_conv_2d(filters = 32, kernel_size = c(3, 3),
                      activation = "relu") %>% 
        layer_max_pooling_2d(pool_size = c(2, 2)) %>% 
        layer_dropout(rate = .2) %>% 
        
        layer_conv_2d(filters = 64, kernel_size = c(3, 3),
                      activation = "relu") %>% 
        layer_max_pooling_2d(pool_size = c(2, 2)) %>%
        layer_dropout(rate = .2) %>% 
        
        layer_conv_2d(filters = 128, kernel_size = c(3, 3),
                      activation = "relu") %>% 
        layer_max_pooling_2d(pool_size = c(28, 2)) %>%
        layer_dropout(rate = .2) %>%
        
        layer_flatten() %>% 
        
        layer_dense(units = 128, activation = "relu") %>% 
        layer_dropout(rate = .5) %>% 
        layer_dense(units = ncol(train$Y), activation = "softmax")

# Print summary
summary(model)
model %>% compile(optimizer = optimizer_adam(decay = 1e-5),
                  loss = "categorical_crossentropy",
                  metrics = "accuracy")

history <- fit(model, x = train$X, y = train$Y,
               batch_size = 16, epochs = 50,
               validation_data = list(val$X, val$Y))

plot(history)

# Save model
# model %>% save_model_hdf5("model.h5")

# Grep species, set colors for heatmap
speciesClass <- gsub(colnames(train$Y), pat = "species", rep = "")
cols <- colorRampPalette(rev(brewer.pal(n = 7, name = "RdGy")))
        
# Validation predictions
predProb <- predict(model, val$X)
predClass <- speciesClass[apply(predProb, 1, which.max)]
trueClass <- speciesClass[apply(val$Y, 1, which.max)]

# Plot confusion matrix
confMat <- confusionMatrix(data = factor(predClass, levels = speciesClass),
                           reference = factor(trueClass, levels = speciesClass))

pheatmap(confMat$table, cluster_rows = F, cluster_cols = F,
         border_color = NA, show_colnames = F,
         labels_row = speciesClass,
         color = cols(max(confMat$table)+1))

# Accuracy in validation set
mean(predClass == trueClass) # 0.7588

# Test set prediction
predXProb <- predict(model, test$X)
predXClass <- speciesClass[apply(predXProb, 1, which.max)]
trueXClass <- speciesClass[apply(test$Y, 1, which.max)]

# Plot confusion matrix
confMatTest <- confusionMatrix(data = factor(predXClass, levels = speciesClass),
                               reference = factor(trueXClass, levels = speciesClass))

pheatmap(confMatTest$table, cluster_rows = F, cluster_cols = F,
         border_color = NA, show_colnames = F,
         labels_row = speciesClass,
         color = cols(max(confMatTest$table)+1))
         
# Accuracy in test set
mean(predXClass == trueXClass) # 0.7074

# Write sessioninfo
writeLines(capture.output(sessionInfo()), "sessionInfo")