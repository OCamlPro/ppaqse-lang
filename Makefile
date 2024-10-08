
SRCS := src/étude/OCamlPro_PPAQSE-COTS_rapport.typ
SRCS += src/présentation/OCamlPro_PPAQSE-COTS_présentation.typ

deps = $(filter-out $(1),$(shell find $(dir $(1)) -name '*.typ'))

BUILD_DIR := _build

PDFS := $(patsubst src/%.typ,$(BUILD_DIR)/%.pdf,$(SRCS))

REGISTRY := registry.ocamlpro.com/ocamlpro/ocpdoc-accueil/typst:latest

VERSION := $(shell git describe --tags --always --dirty)

TYPST_ARGS = --root=/document
TYPST_ARGS += --input git_version="$(VERSION)"
TYPST_ARGS += --font-path src/fonts/Marianne

# Allow second expansion.
.SECONDEXPANSION:

# Define the suffixes used in this project.
.SUFFIXES:
.SUFFIXES: .typ .pdf

# Disabel built-in rules
MAKEFLAGS += --no-builtin-rules

all: $(PDFS)

watch:
	while inotifywait -e close_write "src/étude/OCamlPro_PPAQSE-COTS_rapport.typ" || true; do make; done

$(BUILD_DIR)/%.pdf: src/%.typ $$(call deps,src/%.typ) $$(dir src/%)/bibliography.yml Makefile | $$(@D)/.
	docker run --rm -v $(CURDIR):/document $(REGISTRY) typst c $(TYPST_ARGS) $<
# force moving file for typst seems to always try building locally oO
	mv -f src/$*.pdf $@

.PRECIOUS: %/.
%/.:
	mkdir -p $@
