## Configuration
## =============

# Parameters
# ----------

# Name of package containing the app to be built.
# Rust does not enforce that the path to the package matches the package name, but
# this makefile does to keep things simple.
# Keep in sync with both
# - `acapPackageConf.setup.appName` in `manifest.json`
# - `package.name` in `Cargo.toml`
PACKAGE ?= hello_world

# The architecture that will be assumed when interacting with the device.
ARCH ?= aarch64

# The IP address of the device to interact with.
DEVICE_IP ?= 192.168.0.90

# The password to use when interacting with the device.
PASS ?= pass

# Other
# -----

# Have zero effect by default to prevent accidental changes.
.DEFAULT_GOAL := help

# Delete targets that fail to prevent subsequent attempts incorrectly assuming
# the target is up to date.
.DELETE_ON_ERROR: ;

# Prevent pesky default rules from creating unexpected dependency graphs.
.SUFFIXES: ;

EAP_INSTALL = cd ${CURDIR}/target/$(ARCH)/$(PACKAGE)/ \
&& sh -c ". /opt/axis/acapsdk/environment-setup-* && eap-install.sh $(DEVICE_IP) $(PASS) $@"


## Verbs
## =====

## Build app for all architectures
build:
	cargo-acap-sdk build --no-docker

## Install app on <DEVICE_IP> using password <PASS> and assuming architecture <ARCH>
install:
	cargo-acap-sdk install --no-docker --address $(DEVICE_IP) --password $(PASS) --target $(ARCH) \
	| grep -v '^to start your application type$$' \
	| grep -v '^  eap-install.sh start$$'

## Remove app from <DEVICE_IP> using password <PASS> and assuming architecture <ARCH>
remove:
	@ $(EAP_INSTALL)

## Start app on <DEVICE_IP> using password <PASS> and assuming architecture <ARCH>
start:
	@ # Don't match the line endings because docker replace LF with CR + LF when given `--tty`
	@ $(EAP_INSTALL) \
	| grep -v '^to stop your application type' \
	| grep -v '^  eap-install.sh stop'

## Stop app on <DEVICE_IP> using password <PASS> and assuming architecture <ARCH>
stop:
	@ $(EAP_INSTALL)

## Build and run app directly on <DEVICE_IP> assuming architecture <ARCH>
##
## Prerequisites:
##
## * The app is installed on the device.
## * The app is stopped.
## * The device has SSH enabled the ssh user root configured.
## * The device is added to `knownhosts`.
run:
	cargo-acap-sdk run \
		--no-docker \
		--password $(PASS) \
		--target $(ARCH) \
		--address $(DEVICE_IP) \
		--package $(PACKAGE)

## Build and execute unit tests on <DEVICE_IP> assuming architecture <ARCH>
##
## Prerequisites:
##
## * The app is installed on the device.
## * The app is stopped.
## * The device has SSH enabled the ssh user root configured.
## * The device is added to `knownhosts`.
test:
	cargo-acap-sdk test \
		--no-docker \
		--password $(PASS) \
		--target $(ARCH) \
		--address $(DEVICE_IP) \
		--package $(PACKAGE)

## Checks
## ------

## Run all other checks
check_all: check_build check_docs check_format check_lint
.PHONY: check_all

## Check that all crates can be built
check_build:
	cargo-acap-sdk build

.PHONY: check_build

## Check that docs can be built
check_docs:
	RUSTFLAGS="-Dwarnings" cargo doc \
		--document-private-items \
		--no-deps \
		--target aarch64-unknown-linux-gnu
.PHONY: check_docs

## Check that the code is formatted correctly
check_format:
	cargo fmt --check
.PHONY: check_format

## Check that the code is free of lints
check_lint:
	RUSTFLAGS="-Dwarnings" cargo clippy \
		--all-targets \
		--no-deps \
		--target aarch64-unknown-linux-gnu
.PHONY: check_lint

## Fixes
## -----

## Attempt to fix formatting automatically
fix_format:
	cargo fmt
.PHONY: fix_format

## Attempt to fix lints automatically
fix_lint:
	cargo clippy --fix
.PHONY: fix_lint


## Nouns
## =====
