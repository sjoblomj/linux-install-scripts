#!/bin/bash
source ../common/menu.sh

menu "Install PDF tools and typesetting systems?" \
    "Install TeX Live (LaTeX etc)" './install.sh texlive-core texlive-latexextra texlive-langeuropean texlive-binextra texlive-formatsextra texlive-mathscience texlive-xetex' \
    "Install mupdf-tools" './install.sh mupdf-tools'
