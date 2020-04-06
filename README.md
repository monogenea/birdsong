# Audio classification in R

Part of the tutorial to be published in my blog [poissonisfish](https://poissonisfish.com). Under development!

## Instructions

The MP3 files and an optional metadata CSV file are part of the [xeno-canto](https://www.xeno-canto.org) repository and hosted in the public Kaggle dataset [Bird songs from Europe (xeno-canto)](https://www.kaggle.com/monogenea/birdsongs-from-europe). Rights to use and share them are listed under the [Terms of Use](https://www.xeno-canto.org/about/terms) page from xeno-canto.

1. Download, unzip and move `mp3/` from the Kaggle dataset to your GitHub repo clone
2. Make sure packages listed on top of `0-prepAudio.R` and `1-classAudio.R` are all installed
3. Execute `0-prepAudio.R`
4. Restart R (recommended) and execute `1-classAudio.R`

### GPU and multi-threading

The analysis was conducted using an iMac Pro machine with AMD graphics cards and 16 threads. Considering Tensorflow GPU support is exclusive to NVIDIA®, the much less restrictive [plaidML](https://github.com/plaidml/plaidml) framework was used instead, deployed from a [Conda environment](https://www.anaconda.com) called `plaidml`. Alternative setups including TensorFlow backends (GPU or CPU-supported) can be easily accommodated.

Also, consider changing the `parallel` and `ncores` argument values used in `0-prepAudio.R` as suits your own machine specs the best.

### Reproducibility

To further improve reproducibility, the Keras model object `model.h5` was included to validate the reported accuracy. It can also be use to make new predictions or train further. Additionally, I am including a `sessionInfo` file that carries detailed information of the package versions and hardware configuration I used.

Feel free to report any issues with reproducing the analysis described in the blog.

## Acknowledgements

I want to thank the xeno-canto community for their work in collecting, documenting and sharing this information.


