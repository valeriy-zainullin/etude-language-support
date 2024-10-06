PROFILE_OPTS := --extensions-dir ./ext_root --user-data-dir ./user_data
ETUDE_EXAMPLES_DIR := ../etude/examples/test/

all: package.vsix
# Если уже есть, переустановит.
	code $(PROFILE_OPTS) --install-extension $<
	code -w $(PROFILE_OPTS) --disable-workspace-trust -a $(ETUDE_EXAMPLES_DIR) -g $(ETUDE_EXAMPLES_DIR)/10-test-shouldfail-comparison.et

log: ./ext_root
	bash -c 'cat ./ext_root/valeriy-zainullin.etude-language-support-*/lsp-server/log.txt'

lsp-server/server: lsp-server/server.cpp
	g++ -o $@ $<

# Не хочется каждый раз ждать eslint,
#   потому пусть запускается только если важные
#   файлы поменялись (те, которые мы изменяем пока).
package.vsix: package.json src/extension.ts lsp-server/server
	vsce package -o $@

clean:
	rm -rf *.vsix ext_root user_data
