#!/bin/bash

# Vorschlag Bildgrösse:
# Eine Länge 300 Pixel, die andere Länge kleiner

# Aufruf: bash makeclasslist.sh *.jpg

# momentanes Arbeitsverzeichnis merken
WD=$(pwd)

# über alle Bilder iterieren
for input in $( ls -1 $@ );
do
    # Datei anzeigen welche bearbeitet wird
    ls $input

    # Dateiname von Pfad trennen
    file=$(basename $input)
    path=$(dirname  $input)

    # Ordner mit Bildern betreten
    cd "$WD/$path"

    # Datei-Endung abschneiden um Dateiname zu extrahieren
    name=$(echo $file | cut -d '.' -f1 )

    # Vorname und Nachname extrahieren
    vorname=$(echo $name | cut -d  '_' -f2 )
    nachname=$(echo $name | cut -d '_' -f1 )

    # Extrahierte Informationen ausgeben
    echo -ne "Bearbeite:\t$vorname "
    echo $nachname

    convert $file -auto-orient -resize 600x600 "resized_$file"

    # draw transparent white rectangle in south position
    convert "resized_$file" -auto-orient -strokewidth 0 -fill "rgba( 255, 255, 255, 0.7 )" -draw "rectangle 0,530 600,600 " "rect_$file"

    # write the name in south position
    convert "rect_$file" -gravity South -pointsize 30 -annotate "+0+2" "$vorname\n$nachname" -flatten "tagged_$file"

    # Ordner mit Bildern verlassen (sonst geht Loop schief)
    cd $WD

done

# Ordner mit Bilder betreten und aufräumen
cd "$WD/$path"

montage tagged_* -mode concatenate -tile 4x5 MONTAGE.jpg
convert MONTAGE.jpg Klassenliste.pdf

rm resized_*
rm rect_*
rm tagged_*
rm MONTAGE.jpg

cd $WD
