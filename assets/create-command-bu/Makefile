.DEFAULT_GOAL := install
.SILENT: install remove
.ONESHELL: install remove

DL_ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DL_USER := $(shell whoami)

install:
ifneq ($(DL_USER),root)
	@echo "[make install]  run as root"
	exit
endif

	echo "[make install]  copy {{COMMAND_NAME}} to /usr/local/bin/{{COMMAND_NAME}}"
	sudo rm -rf /usr/local/bin/{{COMMAND_NAME}}
	sudo cp -nf "${DL_ROOT_DIR}/{{COMMAND_NAME}}" /usr/local/bin/{{COMMAND_NAME}}

remove:
ifneq ($(DL_USER),root)
	@echo "[make remove]  run as root"
	exit
endif

	echo "[make remove]  removing /usr/local/bin/{{COMMAND_NAME}}"
	[ -f /usr/local/bin/{{COMMAND_NAME}} ] && sudo rm -rf /usr/local/bin/{{COMMAND_NAME}}
