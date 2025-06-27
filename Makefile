# SPDX-License-Identifier: GPL-3.0-or-later
.ONESHELL:
SHELL := /usr/bin/env
.SHELLFLAGS := bash -euo pipefail -c

.DELETE_ON_ERROR:
.DEFAULT_GOAL := default

define get_executable =
	$(or 																						\
		$(shell command -v ${1}),																\
		$(error $(shell printf "\e[31m%s\n%s\e[0m\n"											\
			"Executable '${1}' is required to execute this Makefile."							\
			"Please install '${1}' and try again."												\
		))																						\
	)
endef

CURL := $(call get_executable,curl)
CURLFLAGS = -L -sS --create-dirs --fail-with-body
curl = ${CURL} ${CURLFLAGS}

TYPST := $(call get_executable,typst)
TYPSTFLAGS :=
typst := ${TYPST} ${TYPSTFLAGS}

PDFTOCAIRO = $(call get_executable,pdftocairo)
PDFTOCAIROFLAGS =
pdftocairo = ${PDFTOCAIRO} ${PDFTOCAIROFLAGS}

MAGICK = $(call get_executable,magick)
MAGICKFLAGS =
magick = ${MAGICK} ${MAGICKFLAGS}

default: start_banner.png end_banner.png
	@echo "Outputs are available in: $^"

original_start_banner.svg:
	${curl} -o "$@" "https://www.noname-ev.de/wiki/uploads/1/13/Banner_2.svg"

original_end_banner.svg:
	${curl} -o "$@" "https://www.noname-ev.de/wiki/uploads/3/3c/Banner_1.svg"

%.svg: %.typ
	${typst} compile -f "svg" "$<" "$@"

%.pdf: %.typ
	${typst} compile -f "pdf" "$<" "$@"

# NOTE: `typst` is capable of producing PNG outputs on its own, but:
# 1. We cannot control the exact output dimensions, we can only approximate them using the DPI. But
#	 even then, the result is never exact and `kdenlive` doesn't handle that well.
# 2. The CC icons are skewered in the conversion process and I have no idea why. There's a weird
#	 kind of offset introduced near the top third. Looks very much like a bug to me.
%.png: %.pdf
	${pdftocairo} -scale-to-x 1920 -scale-to-y 1080 -singlefile -png "$<" "$*"

# Ensures the files are "rebuilt" when any of their prerequisites (defined later on) are updated.
# Otherwise changes to e.g. the `config.yml` or `common.typ` will not cause a rebuild. Since the
# files are part of the git repo it's safe to assume they always exist.
start_banner.typ end_banner.typ:
	@touch -c "$@"

# Use rasterized versions of the logos because typst ruins the SVGs for display.
start_banner.typ end_banner.typ: common.typ cc_icon_logo.jpeg cc_icon_sa.jpeg cc_icon_by.jpeg

cc_icon_logo.svg:
	${curl} -o "$@" "https://mirrors.creativecommons.org/presskit/icons/cc.svg"

cc_icon_sa.svg:
	${curl} -o "$@" "https://mirrors.creativecommons.org/presskit/icons/sa.svg"

cc_icon_by.svg:
	${curl} -o "$@" "https://mirrors.creativecommons.org/presskit/icons/by.svg"

# Transforms the SVG to JPEG, because the SVG uses ridiculously small dimensions for display. Now in
# theory this shouldn't be a problem, of course, but both `typst` and `kdenlive` cannot sensible
# handle this. Both rasterize the SVG for final display and it looks *horrible*.
# But at least this transformation allows us to adapt the colors in the final output to align with
# our slide theme.
cc_icon_%.jpeg: cc_icon_%.svg
	sed -E -e 's/path /path fill="#E12617" /g' -e 's/FFFFFF/000000/g' "$<" > "nnev_$<"
	${magick} -background "#000000" -density 1200 -quality 92 "nnev_$<" "$@"
	rm -f "nnev_$<"


#
# Config handling
#
start_banner.typ: config.yml

# No reason to be so strict with naming
%.yml: %.yaml
	cp "$<" "$@"

config.yml:
	@cat <<-YAML > "$@"
		title: Ein recht langer Titel
		subtitle: |
		    Untertitel
		    mit Zeilenumbruch!
		author: Chaotischer Chaot
		date: 2025-06-12
	YAML


.PHONY: clean
clean:
	rm -rf cc_icon_logo.jpeg cc_icon_sa.jpeg cc_icon_by.jpeg

.PHONY: mrproper
mrproper: clean
	git clean -dfX

