Beschreibung 
========================================================================

Der NeoLayoutViewer bietet eine einfache Möglichkeit, das NEO2-
Tastaturlayout¹ auf dem Bildschirm anzuzeigen.

Eine Ebene wird angezeigt, sobald eine der zugehörigen Mod-Tasten 
gedrückt wird. Dabei kann auch wenn ein anderes Fenster
selektiert sein.

Autoren: Olaf Schulz 2011, rixx 2013
Lizenz: GPLv3


Kompilieren / Installation
========================================================================

Das Programm kann nur kompiliert werden, wenn Vala (mind. Version 0.16) und einige Header
installiert sind. Installation der Abhängigkeiten unter Ubuntu (12.04, Stand September 2013):

    sudo apt-get install valac libgee-dev libgtk-3-dev libx11-dev libunique-3.0-dev libappindicator3-dev


Danach zum Kompilieren in einem Terminal 

    make

eingeben. Nach erfolgreicher Kompilierung liegen die Programmdaten
im Unterverzeichnis `bin/`.


Hinweise
========================================================================
- Beim ersten Start wird die Datei neo_layout_viewer.conf erstellt. (Im
  Verzeichnis, in dem der Befehl ausgeführt wird.) In ihr
  können einige Einstellungen definiert werden. Unter anderem
  - Tastenkürzel für Anzeige und Bewegung des Fensters,
  - Breite des Fensters und
  - Anzeige des Numblocks/der Funktionstasten.	

- Das Programm kann auch ein Trayicon anzeigen. Dazu muss im Makefile
  die Option "ICON" geändert werden.


______________________________________________________________________
¹NEO ist eine Tastaturbelegung, welche für die deutsche Sprache optimiert ist. 
 Die offizielle Seite des Projektes: http://neo-layout.org/
 Mailingliste: http://wiki.neo-layout.org/wiki/Mailingliste
