FROM quay.io/bgruening/docker-jupyter-notebook:21.10
ARG GIT_REPO
RUN conda remove --force-remove -y _libgcc_mutex _r-mutex \
    binutils_impl_linux-64 binutils_linux-64 gcc_impl_linux-64 gcc_linux-64 \
    gfortran_impl_linux-64 gfortran_linux-64 gxx_impl_linux-64 gxx_linux-64 \
    kernel-headers_linux-64 ld_impl_linux-64 libgcc-devel_linux-64 libgcc-ng \
    libstdcxx-devel_linux-64 libprotobuf r-askpass r-assertthat r-backports \
    r-base r-base64enc r-bit r-bit64 r-bitops r-blob r-brew r-brio r-broom \
    r-bslib r-cachem r-callr r-caret r-cellranger r-class r-cli r-clipr \
    r-codetools r-colorspace r-commonmark r-covr r-cpp11 r-crayon r-credentials \
    r-crosstalk r-curl r-data.table r-dbi r-dbplyr r-desc r-devtools r-diffobj \
    r-digest r-dplyr r-dt r-ellipsis r-evaluate r-fansi r-farver r-fastmap \
    r-forcats r-foreach r-forecast r-fracdiff r-fs r-future r-future.apply \
    r-generics r-gert r-ggplot2 r-gh r-git2r r-gitcreds r-globals r-glue r-gower \
    r-gtable r-haven r-hexbin r-highr r-hms r-htmltools r-htmlwidgets r-httpuv \
    r-httr r-ini r-ipred r-irdisplay r-irkernel r-isoband r-iterators \
    r-jquerylib r-jsonlite r-kernsmooth r-knitr r-labeling r-later r-lattice \
    r-lava r-lazyeval r-lifecycle r-listenv r-lmtest r-lubridate r-magrittr \
    r-mass r-matrix r-memoise r-mgcv r-mime r-modelmetrics r-modelr r-munsell \
    r-nlme r-nnet r-numderiv r-nycflights13 r-openssl r-parallelly r-pbdzmq \
    r-pillar r-pkgbuild r-pkgconfig r-pkgload r-plogr r-plyr r-praise \
    r-prettyunits r-proc r-processx r-prodlim r-progress r-progressr r-promises \
    r-ps r-purrr r-quadprog r-quantmod r-r6 r-randomforest r-rappdirs \
    r-rcmdcheck r-rcolorbrewer r-rcpp r-rcpparmadillo r-rcurl r-readr r-readxl \
    r-recipes r-rematch r-rematch2 r-remotes r-repr r-reprex r-reshape2 r-rex \
    r-rlang r-rmarkdown r-roxygen2 r-rpart r-rprojroot r-rsqlite r-rstudioapi \
    r-rversions r-rvest r-sass r-scales r-selectr r-sessioninfo r-shiny \
    r-sourcetools r-squarem r-stringi r-stringr r-survival r-sys r-testthat \
    r-tibble r-tidyr r-tidyselect r-tidyverse r-timedate r-tinytex r-tseries \
    r-ttr r-tzdb r-urca r-usethis r-utf8 r-uuid r-vctrs r-viridislite r-vroom \
    r-waldo r-whisker r-withr r-xfun r-xml r-xml2 r-xopen r-xtable r-xts r-yaml \
    r-zip r-zoo sysroot_linux-64 && sudo apt update && sudo apt install dirmngr \
    gnupg apt-transport-https ca-certificates software-properties-common -y && \
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/' && sudo apt update && \
    sudo apt install r-base libudunits2-dev libproj-dev libgdal-dev libjq-dev -y && \
    curl https://raw.githubusercontent.com/Bioconductor/bioconductor_docker/master/bioc_scripts/install_bioc_sysdeps.sh -o /tmp/install_deps.sh && \
    sh /tmp/install_deps.sh && Rscript -e 'install.packages("IRkernel"); install.packages("BiocManager");' && \
    Rscript -e 'BiocManager::install("remotes"); BiocManager::install("forcats")' && \
    Rscript -e 'if(BiocManager::install("geojsonio", dependencies = TRUE) %in% rownames(installed.packages())) q(status = 0) else q(status = 1)' && \
    curl https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/install_quarto.sh | bash

USER jovyan
RUN echo $GIT_REPO > /home/jovyan/gitrepo && REPONAME=$(echo $GIT_REPO | awk -F'/' '{print $NF}'); git clone https://github.com/${GIT_REPO} /home/jovyan/$REPONAME && cd /home/jovyan/$REPONAME && ls vignettes/* | grep ".qmd" | xargs -i bash .github/scripts/install_missing.sh {}

ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++
