// SPDX-License-Identifier: GPL-3.0-or-later
#let theme = (
    background: rgb("#000000"),
    foreground: rgb("#E12617"),
    fontsizes: (
        title: 24pt,
        subtitle: 18pt,
        author: 18pt,
        date: 18pt,
    ),
)

#let banner(content, theme: theme) = {
    set text(
        fill: theme.foreground,
        hyphenate: false,
        font: "DejaVu Sans Mono",
    )
    set par(justify: true)
    set align(center)

    page(
        numbering: none,
        footer: none,
        header: none,
        margin: 0pt,
        width: 16cm,
        height: 9cm,
        fill: theme.background,
    )[
        #content
        #place(center + bottom,
            block(
                height: 2cm,
                width: 90%,
                spacing: 0pt,
                inset: (
                    bottom: 0.3cm,
                ),
            )[
                #grid(
                    columns: (1cm, 1cm, 1cm),
                    gutter: 5pt,
                    align: (center, center, center),
                    image("nnev_cc_icon_logo.svg"),
                    image("nnev_cc_icon_by.svg"),
                    image("nnev_cc_icon_sa.svg"),
                )
                #v(-0.7em)
                #link("https://creativecommons.org/licenses/by-sa/4.0/")
            ]
        )
    ]
}
