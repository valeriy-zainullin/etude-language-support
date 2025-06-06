PROFILE_OPTS := --extensions-dir ./ext_root --user-data-dir ./user_data
ETUDE_SAMPLE_PROJ_DIR := et-irc
ETUDE_EXAMPLES_DIR := etuded/etude/examples/test/

all: package.vsix

preview: package.vsix
	code $(PROFILE_OPTS) --install-extension $<
	code -w $(PROFILE_OPTS) --disable-workspace-trust -a $(ETUDE_SAMPLE_PROJ_DIR)
	# code -w $(PROFILE_OPTS) --disable-workspace-trust -a $(ETUDE_EXAMPLES_DIR)

etuded/build:
	cmake -B etuded/build -DCMAKE_BUILD_TYPE=Debug etuded

PHONY += etuded/build/server # Всегда нужно посмотреть, надо ли пересобрать.
etuded/build/server: | etuded/build
	$(MAKE) -j$(shell nproc) -C etuded/build

lsp-server: etuded/build/server
	cp $< $@

etude_stdlib: | etuded/etude/stdlib
	cp -r $| $@

# Не хочется каждый раз ждать eslint,
#   потому пусть запускается только если важные
#   файлы поменялись (те, которые мы изменяем пока).
package.vsix: package.json src/extension.ts lsp-server etude_stdlib
  # Если уже есть, переустановит.
	npx vsce package -o $@

clean:
	rm -rf *.vsix ext_root user_data etuded/build lsp_server

.PHONY: $(PHONY)

