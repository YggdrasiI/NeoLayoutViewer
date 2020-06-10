
Der Ordner "graphics" enthält die verwendeten Grafiken für das Tastaturlayout NEO2, ADNW und KOY als svg (scalable vector graphics).

Diese können mit einem Vektorgrafikprogramm wie z.B. Inkscape editiert werden, um ein anderes Layout zu erzeugen.
Anschließend kann jede Ebene des SVGs als png (portable_network_graphics) im Format 1000 x 250 Pixel (ohne Funktionstasten-Zeile) exportiert und unter /assets/<layoutname>/ abgespeichert werden.

Das Skript 'svg_to_png/convert_svg.py' automatisiert die Erzeugung der PNG-Dateien.

Das für die Anordnung der Buchstaben auf der Bildschirmtastatur zuständige Key Array befindet sich am Ende der Datei "key-overlay.vala".

