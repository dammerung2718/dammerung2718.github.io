FD       = fdfind
MARKDOWN = $(wildcard docs/*.md)
HTML     = $(MARKDOWN:.md=.html)

.PHONY: generate
generate: clean $(HTML)

.PHONY: %.html
%.html: %.md
	pandoc -f markdown -t html -o $@ $^
	sed -e '/CONTENT/{r $@' -e 'd}' template | sponge $@
	tidy -im $@ 2>/dev/null

.PHONY: dev
dev:
	$(FD) -e md | entr -cr make

.PHONY: serve
serve:
	cd docs && python3 -m http.server

.PHONY: clean
clean:
	$(FD) . docs -e html -x rm
