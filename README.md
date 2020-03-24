# Audio classification in R

Part of the tutorial to be published in my blog [poissonisfish](https://poissonisfish.com). Under development!

## Instructions

The data are part of the [xeno-canto](https://www.xeno-canto.org) collection and hosted in the public Kaggle dataset [Bird songs from Europe (xeno-canto)](https://www.kaggle.com/monogenea/birdsongs-from-europe), alongside an optional metadata CSV file. Rights to use and share them are listed under the [Terms of Use](https://www.xeno-canto.org/about/terms) page from xeno-canto.

1. Download `mp3/` from the Kaggle dataset into your GitHub repo clone
2. Execute `0-prepAudio.R` after installing the libraries listed on top if necessary
3. Restart R (recommended) and execute `1-classAudio.R`

### GPU and multi-threading

I am using an iMac Pro machine with AMD graphics cards and 16 threads. Since Tensorflow-supported GPU acceleration is practically exclusive to NVIDIA, I used the [plaidML](https://github.com/plaidml/plaidml) framework as an alternative. In any case, you can easily adapt the code to use the TensorFlow backend instead.

Also, consider changing the `parallel` and `ncores` argument values used in `0-prepAudio.R` as suits your own machine specs the best.

### Reproducibility

To further improve reproducibility, I included the Keras model object `model.h5` that you can use to validate the reported accuracy. Additionally, to prevent discrepancies due to R package versioning I am including a `sessionInfo` file that carries detailed information of all used package versions and machine specs.

Feel free to report any issues with reproducing the analysis described in the blog.

## Acknowledgements

I want to thank the xeno-canto community for their work in collecting, documenting and sharing this wealth of information.


