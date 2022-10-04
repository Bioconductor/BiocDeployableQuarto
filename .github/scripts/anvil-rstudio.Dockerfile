# Run with docker build --build-arg GIT_REPO="account/repo"
FROM us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.15.2
ARG GIT_REPO
RUN curl https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/install_quarto.sh | bash
USER rstudio
RUN cd /home/rstudio && git clone https://github.com/${GIT_REPO} && cd $(echo "${GIT_REPO}" | awk -F/ '{print $NF}') && ls vignettes/* | grep ".qmd" | xargs -i bash .github/scripts/install_missing.sh {}
