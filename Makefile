COFFEE := $(wildcard src/*.coffee)
JS := $(patsubst src%, lib%, $(COFFEE:.coffee=.js))

.PHONY: all clean prepublish test testem

all: index.js cli.js $(JS)

%.js: %.coffee
	@$(eval input := $<)
	@coffee -c $(input)

$(JS): $(1)

lib/%.js: src/%.coffee
	@$(eval input := $<)
	@$(eval output := $@)
	@coffee -pc $(input) > $(output)

clean:
	@rm -f index.js cli.js $(JS)

prepublish: clean all

test:
	@mocha --reporter spec test

tap:
	@testem ci

testem:
	@testem
