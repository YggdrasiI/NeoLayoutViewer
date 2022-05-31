convert_svg.sh erstellt für alle Ebenen PNGs,
und ergänzt die Bilder um die Reihe mit den Funktionstasten
sowie Beschriftungen des Cursor-Blocks.

Abhängigkeiten:
  ImageMagick (convert)


Aufruf-Beispiele:
  python3 convert_svg.py ../tastatur_neo_alle_Ebenen.svg tastatur_neo
  python3 convert_svg.py ../Tastatur_ADNW_alle_Ebenen.svg tastatur_adnw
  python3 convert_svg.py ../Tastatur_KOY_alle_Ebenen.svg tastatur_koy


SVG-Quelle:
  https://github.com/neo-layout/neo-layout/tree/master/grafik/tastatur3d

  Neue Layouts sollten für eine einheitlichere Darstellung auf Grundlage der
  mit dem Neolayoutviewer mitgelieferten Tastatur_<Bez.>_alle_Ebenen.svg
  erstellt werden.

  Achtung, diese alte Datei müssen Sie erst mit Inkskape neu speichern, 
  bevor sie von ImageMagick verarbeitet werden kann.
