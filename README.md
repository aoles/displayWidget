# Installation

Use the `biocLite` installation script in order to resolve dependency on the Bioconductor package *EBImage*.

```r
source("https://bioconductor.org/biocLite.R")
biocLite("aoles/displayWidget") # You might need to first run `install.packages("devtools")`
```

# Documentation

See the [package vignette](https://rawgit.com/aoles/displayWidget/master/vignettes/vignette.html) for a demo.

# Demo

Example use in a Shiny app.

```r
runApp( system.file("shiny", package="displayWidget") )
```
