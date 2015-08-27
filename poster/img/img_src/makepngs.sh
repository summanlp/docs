#!/usr/bin/env bash

for archivo_tex in $(ls *.tex); 
    do
    echo "$archivo_tex"
    pdflatex "$archivo_tex"
    convert -density 300 "${archivo_tex%.*}.pdf" -quality 90 "${archivo_tex%.*}.png";
    rm *.log *.pdf *.aux
done
