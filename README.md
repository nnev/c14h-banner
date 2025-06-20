# c14h Start-/Endfolien

<!--toc:start-->
- [c14h Start-/Endfolien][0]
    - [Benutzen][a]
    - [Lizenz][d]

[0]: #c14h-start-endfolien
[a]: #benutzen
[d]: #lizenz
<!--toc:end-->

Die Start- und Endfolien bzw. Banner für die Videouploads der [chaotischen Viertelstunden][1].

[1]: https://www.noname-ev.de/chaotische_viertelstunde.html


## Benutzen

Dieses repo nutzt GNU `make` als Buildsystem und einen OCI-Container für das Verwalten der
Abhängigkeiten. Um das repo zu benutzen, müssen wenigstens folgende Programme installiert sein:

- [GNU bash][a0]
- [GNU coreutils][a1] (oder eine andere Implementierung von `realpath`, `basename` und `dirname`)
- [podman][a2]

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
> Abhängigkeiten auch lokal installieren. Das [Containerfile.develop][a3] zeigt, was benötigt wird.
> **Für dieses Setup gibt es allerdings keine Unterstützung von uns!**

[a0]: https://www.gnu.org/software/bash/
[a1]: https://www.gnu.org/software/coreutils/
[a2]: https://podman.io/
[a3]: ./Containerfile.develop


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
