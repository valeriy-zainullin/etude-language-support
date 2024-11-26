PROFILE_OPTS := --extensions-dir ./ext_root --user-data-dir ./user_data
ETUDE_EXAMPLES_DIR := ../etude/examples/test/

all: package.vsix
# Если уже есть, переустановит.
	code $(PROFILE_OPTS) --install-extension $<
	code -w $(PROFILE_OPTS) --disable-workspace-trust -a $(ETUDE_EXAMPLES_DIR) -g $(ETUDE_EXAMPLES_DIR)/10-test-shouldfail-comparison.et

etuded/build:
	cmake -B etuded/build etuded

PHONY += etuded/build/server # Всегда нужно посмотреть, надо ли пересобрать.
etuded/build/server: | etuded/build
	$(MAKE) -j$(nproc) -C etuded/build

etuded/server: etuded/build/server
	cp $< $@

# Не хочется каждый раз ждать eslint,
#   потому пусть запускается только если важные
#   файлы поменялись (те, которые мы изменяем пока).
package.vsix: package.json src/extension.ts etuded/server
	vsce package -o $@

clean:
	rm -rf *.vsix ext_root user_data

.PHONY: $(PHONY)

