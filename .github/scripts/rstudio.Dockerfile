# Run with docker build --build-arg GIT_REPO="account/repo"
FROM bioconductor/bioconductor_docker:devel
ARG GIT_REPO
USER rstudio
RUN cd /home/rstudio && git clone https://github.com/${GIT_REPO} && cd $(echo "${GIT_REPO}" | awk -F/ '{print $NF}') && ls vignettes/* | grep ".qmd" | xargs -i bash .github/scripts/install_missing.sh {}
