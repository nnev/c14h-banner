// SPDX-License-Identifier: GPL-3.0-or-later
#import("common.typ"): *

#let metadata = {
    let obj = (:)
    let config_dict = () => {
        let config_path = "config.yml"
        let raw_config = yaml(config_path)

        if type(raw_config) == dictionary {
            raw_config
        } else {
            panic("The config file '" + config_path + "' must specify a dictionary/key-value mapping")
        }
    }

    let update_key(obj, key, required: true, transform: x => x) = {
        if key in sys.inputs {
            obj.insert(key, transform(sys.inputs.at(key)))
        } else if key in config_dict() {
            obj.insert(key, transform(config_dict().at(key)))
        } else {
            if required {
                panic("required variable '" + str(key) + "' is undefined")
            }
        }
        obj
    }

    obj = update_key(obj, "title")
    obj = update_key(obj, "subtitle", required: false)
    obj = update_key(obj, "author")
    obj = update_key(obj, "date", transform: dt => {
        let year_pattern = "(?P<year>\d{4})"
        let month_pattern = "(?P<month>(?:0?[1-9])|(?:1[0-2]))"
        let day_pattern = "(?P<day>(?:0?[0-9])|(?:[12][0-9])|(?:3[01]))"
        let match = dt.match(regex("^" + year_pattern + "-" + month_pattern + "-" + day_pattern + "$"))

        if match == none {
            panic("Date string must satisfy format 'yyyy-mm-dd'")
        } else {
            datetime(
                year: int(match.captures.at(0)),
                month: int(match.captures.at(1)),
                day: int(match.captures.at(2)),
            )
        }
    })

    obj
}

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

