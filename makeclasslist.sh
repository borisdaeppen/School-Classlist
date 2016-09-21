#!/bin/bash

# Vorschlag Bildgrösse:
# Eine Länge 300 Pixel, die andere Länge kleiner

# Aufruf: bash makeclasslist.sh *.jpg

# über alle Bilder iterieren
for file in $( ls -1 $@ );
do
    # Datei anzeigen welche bearbeitet wird
    ls $file

    # Datei-Endung abschneiden um Dateiname zu extrahieren
    name=$(echo $file | cut -d '.' -f1 )

    # Vorname und Nachname extrahieren
    vorname=$(echo $name | cut -d '_' -f1 )
    nachname=$(echo $name | cut -d '_' -f2 )

    # Extrahierte Informationen ausgeben
    echo -ne "Bearbeite:\t$vorname "
    echo $nachname

    convert $file -resize 300x300 "resized_$file"

    # draw transparent white rectangle in south position
    convert "resized_$file" -strokewidth 0 -fill "rgba( 255, 255, 255, 0.7 )" -draw "rectangle 0,230 300,300 " "rect_$file"

    # write the name in south position
    convert "rect_$file" -gravity South -pointsize 30 -annotate "+0+2" "$vorname\n$nachname" -flatten "tagged_$file"

done

montage tagged_* -tile 4x5 MONTAGE.jpg
convert MONTAGE.jpg Klassenliste.pdf

rm resized_*
rm rect_*
rm tagged_*
rm MONTAGE.jpg
