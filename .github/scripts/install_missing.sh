#!/bin/bash
QMD=$(realpath "$1")
echo $QMD
mkdir -p /tmp
# Extract missing R pkg or Python module from quarto error message
while ( quarto render $QMD --to html 3>&1 1>&2- 2>&3- ) | grep "Error in loadNamespace(x) : there is no package called" > /tmp/rmissingpkg \
 || ( quarto render $QMD --to html 3>&1 1>&2- 2>&3- ) | grep "ModuleNotFoundError: No module named" > /tmp/pymissingmodule;
do
    if [[ -s /tmp/rmissingpkg ]]; then
        RPKG=$(awk '{print $NF}' /tmp/rmissingpkg)
        # Link reticulate with existing python3
        if [ $RPKG == "'reticulate'" ]; then Rscript -e "library(reticulate); use_python('$(which python3)')"; fi
        # Install missing R package
        Rscript -e "BiocManager::install($RPKG)" && rm /tmp/rmissingpkg
    elif [[ -s /tmp/pymissingmodule ]]; then
        PYMOD=$(awk '{print $NF}' /tmp/pymissingmodule | sed "s/'//g")
        # Install missing python module
        python3 -m pip install $PYMOD && rm /tmp/pymissingmodule
    fi
done
