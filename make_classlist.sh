#!/bin/bash

# Vorschlag Bildgrösse:
# Eine Länge 300 Pixel, die andere Länge kleiner

for file in $( ls -1 $@ );
do
    ls $file
    name=$(echo $file | cut -d '.' -f1 )
    vorname=$(echo $name | cut -d '_' -f1 )
    nachname=$(echo $name | cut -d '_' -f2 )
    echo -ne "Bearbeite:\t$vorname "
    echo $nachname

    # draw transparent white rectangle in south position
    convert $file -strokewidth 0 -fill "rgba( 255, 255, 255, 0.5 )" -draw "rectangle 0,230 300,300 " "rect_$file"
    # write the name in south position
    convert "rect_$file" -gravity South -pointsize 30 -annotate "+0+10" "$vorname $nachname" -flatten "tagged_$file"

done

montage tagged_* -tile 4x5 MONTAGE.jpg
convert MONTAGE.jpg Klassenliste.pdf

rm rect_*
rm tagged_*
rm MONTAGE.jpg
