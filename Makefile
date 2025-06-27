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

default: start_banner.png end_banner.png
	@echo "Outputs are available in: $^"

original_start_banner.svg:
	${curl} -o "$@" "https://www.noname-ev.de/wiki/uploads/1/13/Banner_2.svg"

original_end_banner.svg:
	${curl} -o "$@" "https://www.noname-ev.de/wiki/uploads/3/3c/Banner_1.svg"

%.svg: %.typ
	${typst} compile -f "svg" "$<" "$@"

%.png: %.typ
	${typst} compile -f "png" --ppi 304.8 "$<" "$@"

# Use rasterized versions of the logos because typst ruins the SVGs for display.
start_banner.typ end_banner.typ: common.typ nnev_cc_icon_logo.svg nnev_cc_icon_sa.svg nnev_cc_icon_by.svg

cc_icon_logo.svg:
	${curl} -o "$@" "https://mirrors.creativecommons.org/presskit/icons/cc.svg"

nnev_cc_icon_logo.svg: cc_icon_logo.svg
	sed -E -e 's/path /path fill="#E12617" /g' -e 's/FFFFFF/000000/g' "$<" > "$@"

cc_icon_sa.svg:
	${curl} -o "$@" "https://mirrors.creativecommons.org/presskit/icons/sa.svg"

nnev_cc_icon_sa.svg: cc_icon_sa.svg
	sed -E -e 's/path /path fill="#E12617" /g' -e 's/FFFFFF/000000/g' "$<" > "$@"

cc_icon_by.svg:
	${curl} -o "$@" "https://mirrors.creativecommons.org/presskit/icons/by.svg"

nnev_cc_icon_by.svg: cc_icon_by.svg
	sed -E -e 's/path /path fill="#E12617" /g' -e 's/FFFFFF/000000/g' "$<" > "$@"

.PHONY: clean
clean:
	rm -f nnev_cc_icon_logo.svg nnev_cc_icon_sa.svg nnev_cc_icon_by.svg
	rm -f start_banner.png end_banner.png
	rm -f start_banner.svg end_banner.svg

.PHONY: mrproper
mrproper: clean
	git clean -dfX
