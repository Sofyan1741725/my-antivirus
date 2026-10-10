DIR ?= monitored_dir
MALICIOUS_DIR ?= malicious_dir
INTERVAL ?= 5

all: pre-build

pre-build:
	@mkdir -p "$(MALICIOUS_DIR)"
	@mkdir -p "$(DIR)"
	@echo "[+] Pre-build step completed: '$(MALICIOUS_DIR)' and '$(DIR)' are ready."

run-daemon: pre-build
	@./antivirusd.sh "$(DIR)" "$(MALICIOUS_DIR)" "$(INTERVAL)"

restore:
	@./restore.sh "$(DIR)" "$(MALICIOUS_DIR)"

clean:
	@rm -f directory-info.last directory-info.new
	@echo "[+] Cleanup completed."

.PHONY: all pre-build run-daemon restore clean
