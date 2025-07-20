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
	@echo -e "\e[1;35mOutputs are available in: $^\e[0m"

# Just for comparison
original_start_banner.svg:
	${curl} -o "$@" "https://www.noname-ev.de/wiki/uploads/1/13/Banner_2.svg"

original_end_banner.svg:
	${curl} -o "$@" "https://www.noname-ev.de/wiki/uploads/3/3c/Banner_1.svg"


#
# Start and End Banner
#
%.svg: %.typ
	${typst} compile -f "svg" "$<" "$@"

%.pdf: %.typ
	${typst} compile -f "pdf" "$<" "$@"

# image is ̂16cm x 9cm
# 1920px/16cm = 1080px/9cm = 1920px/(16/2.54)inch = 1080px/(9/2.54)inch
# = 304.8 px/inch
%.png: %.typ
	${typst} compile -f "png" --ppi 304.8 "$<" "$@"

# Ensures the files are "rebuilt" when any of their prerequisites (defined later on) are updated.
# Otherwise changes to e.g. the `config.yml` or `common.typ` will not cause a rebuild. Since the
# files are part of the git repo it's safe to assume they always exist.
start_banner.typ end_banner.typ:
	@touch -c "$@"

# Use rasterized versions of the logos because typst ruins the SVGs for display.
start_banner.typ end_banner.typ: \
	common.typ nnev_cc_icon_logo.svg nnev_cc_icon_sa.svg nnev_cc_icon_by.svg
end_banner.typ: nnev_logo_red.svg

cc_icon_logo.svg:
	${curl} -o "$@" "https://mirrors.creativecommons.org/presskit/icons/cc.svg"

cc_icon_sa.svg:
	${curl} -o "$@" "https://mirrors.creativecommons.org/presskit/icons/sa.svg"

cc_icon_by.svg:
	${curl} -o "$@" "https://mirrors.creativecommons.org/presskit/icons/by.svg"

nnev_logo_red.svg: nnev_logo.svg
	sed -E -e 's/fill:#000000/fill:#E12617/g' "$<" > "$@"

nnev_cc_icon_%.svg: cc_icon_%.svg
	sed -E -e 's/path /path fill="#E12617" /g' -e 's/FFFFFF/000000/g' "$<" > "$@"

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


#
# Maintenance and stuff
#
.PHONY: clean
clean:
	rm -f nnev_cc_icon_{logo,sa,by}.svg
	rm -f {start,end}_banner.{png,svg,pdf}

.PHONY: mrproper
mrproper: clean
	git clean -dfX

