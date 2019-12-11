#!/bin/bash

python_version_major=2.7
python_version=${python_version_major}.13

echo -e '\033[0;32m--- Install custom SSB python library (standard python) --- \033[0m'
pip install ssb-pseudonymization

# Install custom SSB python library with conda env
# This also takes care of dependencies
echo -e '\033[0;32m--- Initialising conda env ---\033[0m'
conda init bash
source /root/.bashrc
conda create -n ssb-env python=$python_version_major pip
conda env list | grep ssb-env
if [[ $? != 0 ]]
then
    echo -e "\033[0;31m--- Creating ssb-env failed ---\033[0m"
    exit 1
fi

echo -e '\033[0;32m--- Activate ssb-env ---\033[0m'
source activate ssb-env
pip install ssb-pseudonymization
echo -e '\033[0;32m--- Packaging ssb-env ---\033[0m'
conda package --pkg-name ssb-env
if [ ! -r ssb-env-*.tar.bz2 ]
then
    echo -e "\033[0;31m--- Packaging ssb-env failed ---\033[0m"
    exit 1
fi

# Create a zip file of the environment (including dependencies)
# This zip file will be distributed to the yarn cluster, and used by pyspark
echo -e '\033[0;32m--- Creating zip file ---\033[0m'
tar -xvf ssb-env-*.tar.bz2 --strip-components=2 lib/python$python_version_major/site-packages/
if [ ! -r site-packages ]
then
    echo -e "\033[0;31m--- Extracting ssb-env failed (site-packages not found) ---\033[0m"
    exit 1
fi

cd site-packages/
zip -9r ../ssb-library.zip .

cd ..
rm ssb-env-*.tar.bz2
rm -R site-packages

exit $?

