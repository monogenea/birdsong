# Audio classification in R

Part of the tutorial from my blog [poissonisfish](https://poissonisfish.com/2020/04/05/audio-classification-in-r/).

## Instructions

The MP3 files and the optional metadata CSV file are part of the [xeno-canto](https://www.xeno-canto.org) collection and hosted in the public Kaggle dataset [Bird songs from Europe (xeno-canto)](https://www.kaggle.com/monogenea/birdsongs-from-europe). Rights to use and share them are listed under the [Terms of Use](https://www.xeno-canto.org/about/terms) page from xeno-canto.

1. Download, unzip and move `mp3/` from the Kaggle dataset to your GitHub repo clone
2. Make sure all packages listed on top of `0-prepAudio.R` and `1-classAudio.R` are installed
3. Execute `0-prepAudio.R`
4. Restart R (recommended) and execute `1-classAudio.R`

### GPU and multi-threading

The analysis was conducted using an iMac Pro machine with AMD graphics cards and 16 threads. Considering Tensorflow GPU support is exclusive to NVIDIA®, the much less restrictive [plaidML](https://github.com/plaidml/plaidml) framework was used instead, deployed from a [Conda environment](https://www.anaconda.com) called `plaidml`. Alternative setups including TensorFlow backends (GPU or CPU-supported) can be easily accommodated.

Also, consider changing `ncores` in `0-prepAudio.R` as suits your machine specs the best.

### Reproducibility

To further improve reproducibility, the Keras model object `model.h5` is included to validate the reported accuracy. Additionally, `sessionInfo` carries detailed information of the package versions and hardware configuration.

Feel free to report any issues with reproducing the analysis described in the blog.

## Acknowledgements

I want to thank the xeno-canto community for their work in collecting, documenting and sharing this information.


