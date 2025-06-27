# c14h Start-/Endfolien

<!--toc:start-->
- [c14h Start-/Endfolien][0]
    - [Benutzen][a]
    - [Vorbereiten][b]
    - [Lizenz][d]

[0]: #c14h-start-endfolien
[a]: #benutzen
[b]: #vorbereiten
[d]: #lizenz
<!--toc:end-->

Die Start- und Endfolien bzw. Banner für die Videouploads der [chaotischen Viertelstunden][1].

[1]: https://www.noname-ev.de/chaotische_viertelstunde.html


## Benutzen

Vor dem ersten Benutzen, sollte man die Ausführung des Projektes [einmal vorbereiten][b].

Die Metadaten für das Startbanner werden aus einer Konfigurationsdatei `config.yml` ausgelesen. Eine
Standardkonfiguration wird automatisch von `make` erzeugt, sofern keine vorhanden ist. Man kann sie
aber mit folgendem Befehl auch händisch erzeugen:

```bash
bin/make config.yml
```

Anschließend muss man die Einstellungen mit einem Editor anpassen. Wenn die Konfiguration die
gewünschten Werte enthält, werden die Banner wie folgt erzeugt:

```bash
bin/make
```

Die erzeugten Dateien zeigt das `Makefile` anschließend in der Ausgabe an.


## Vorbereiten

Dieses repo nutzt GNU `make` als Buildsystem und einen OCI-Container für das Verwalten der
Abhängigkeiten. Um das repo zu benutzen, müssen wenigstens folgende Programme installiert sein:

- [GNU bash][b0]
- [GNU coreutils][b1] (oder eine andere Implementierung von `realpath`, `basename` und `dirname`)
- [podman][b2]

Anschließend baut man einmal den Container:

```bash
source .env
podman build -t "$CONTAINER_IMAGE:$CONTAINER_TAG" -f "Containerfile.develop" .
```

Danach sollte folgender Befehl "einfach funktionieren":

```bash
bin/make
```

> Hinweis: Sofern die Installation/Anwendung von `podman` keine Option ist, kann man die benötigten
> Abhängigkeiten auch lokal installieren. Das [Containerfile.develop][b3] zeigt, was benötigt wird.
> **Für dieses Setup gibt es allerdings keine Unterstützung von uns!**

[b0]: https://www.gnu.org/software/bash/
[b1]: https://www.gnu.org/software/coreutils/
[b2]: https://podman.io/
[b3]: ./Containerfile.develop


## Lizenz

Copyright (C)  2025 Andreas Hartmann

This program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License in [the LICENSE file][d0] along
with this program. If not, see <https://www.gnu.org/licenses/>.

[d0]: ./LICENSE
