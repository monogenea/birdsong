# Audio classification in R

Part of the tutorial to be published in my blog [poissonisfish](https://poissonisfish.com). Under development!

## Instructions

The data are part of the [xeno-canto](https://www.xeno-canto.org) collection and hosted in the public Kaggle dataset [Bird songs from Europe (xeno-canto)](https://www.kaggle.com/monogenea/birdsongs-from-europe), alongside an optional metadata CSV file. Rights to use and share them are listed under the [Terms of Use](https://www.xeno-canto.org/about/terms) page from xeno-canto.

1. Download `mp3/` into your repo clone
2. Execute `0-prepAudio.R` after installing libraries listed on top if necessary
3. Restart R (recommended) and execute `1-classAudio.R`

NOTE: I am using an iMac machine with AMD graphic cards and 16 threads. I used the [plaidML](https://github.com/plaidml/plaidml) framework as an alternative to TensorFlow to enable GPU acceleration, you can easily modify the code to use TensorFlow instead. Also, change the `parallel` and `ncores` arguments invoked in `0-prepAudio.R` accordingly based on your own machine specs.

## Acknowledgements

I want to thank the xeno-canto community for their work in collecting, documenting and sharing this wealth of information.


