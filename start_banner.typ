// SPDX-License-Identifier: GPL-3.0-or-later
#import("common.typ"): *

#let metadata = (
    title: "Ein recht langer Titel",
    subtitle: "Untertitel\nmit Zeilenumbruch!",
    author: "Chaotischer Chaot",
    date: datetime(year: 2025, month: 06, day: 12),
)

#banner[
    #block(
        height: 4cm,
        width: 90%,
        spacing: 0pt,
        inset: (
            top: 0.5cm,
        ),
        align(
            horizon,
        )[
            #text(theme.fontsizes.title, metadata.title, weight: "bold")
            #v(1.6em, weak: true)
            #text(theme.fontsizes.subtitle, metadata.subtitle, weight: "bold")
        ],
    )
    #block(
        height: 3cm,
        width: 90%,
        spacing: 0pt,
        inset: (
            top: 0.5cm,
        ),
        align(
            horizon,
        )[
            #text(theme.fontsizes.author, metadata.author, weight: "bold")
            #v(0.5cm, weak: true)
            #text(theme.fontsizes.date, metadata.date.display("[year]-[month]-[day]"))
        ]
    )
]

