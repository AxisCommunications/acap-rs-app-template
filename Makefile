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
export AXIS_PACKAGE ?= hello_world

# The architecture that will be assumed when interacting with the device.
export AXIS_DEVICE_ARCH ?= aarch64

# The IP address of the device to interact with.
export AXIS_DEVICE_IP ?= 192.168.0.90

# The username to use when interacting with the device.
export AXIS_DEVICE_USER ?= root

# The password to use when interacting with the device.
export AXIS_DEVICE_PASS ?= pass

# Other
# -----

# Have zero effect by default to prevent accidental changes.
.DEFAULT_GOAL := none

# Delete targets that fail to prevent subsequent attempts incorrectly assuming
# the target is up to date.
.DELETE_ON_ERROR: ;

# Prevent pesky default rules from creating unexpected dependency graphs.
.SUFFIXES: ;

# It doesn't matter which SDK is sourced for installing, but using a wildcard would fail since there are multiple in the container.
EAP_INSTALL = cd $(CURDIR)/target/$(AXIS_DEVICE_ARCH)/$(AXIS_PACKAGE)/ \
&& . /opt/axis/acapsdk/environment-setup-cortexa53-crypto-poky-linux && eap-install.sh $(AXIS_DEVICE_IP) $(AXIS_DEVICE_PASS) $@


## Verbs
## =====

none:;

## Reset <AXIS_DEVICE_IP> using password <AXIS_DEVICE_PASS> to a clean state suitable for development and testing.
reinit:
	RUST_LOG=info device-manager reinit

## Build app for <AXIS_DEVICE_ARCH>
build:
	cargo-acap-build --target $(AXIS_DEVICE_ARCH) -- -p $(AXIS_PACKAGE)

## Install app on <AXIS_DEVICE_IP> using password <AXIS_DEVICE_PASS> and assuming architecture <AXIS_DEVICE_ARCH>
install:
	@ $(EAP_INSTALL) \
	| grep -v '^to start your application type$$' \
	| grep -v '^  eap-install.sh start$$'

## Remove app from <AXIS_DEVICE_IP> using password <AXIS_DEVICE_PASS> and assuming architecture <AXIS_DEVICE_ARCH>
remove:
	@ $(EAP_INSTALL)

## Start app on <AXIS_DEVICE_IP> using password <AXIS_DEVICE_PASS> and assuming architecture <AXIS_DEVICE_ARCH>
start:
	@ $(EAP_INSTALL) \
	| grep -v '^to stop your application type$$' \
	| grep -v '^  eap-install.sh stop$$'

## Stop app on <AXIS_DEVICE_IP> using password <AXIS_DEVICE_PASS> and assuming architecture <AXIS_DEVICE_ARCH>
stop:
	@ $(EAP_INSTALL)

## Build and run app directly on <AXIS_DEVICE_IP> assuming architecture <AXIS_DEVICE_ARCH>
##
## Prerequisites:
##
## * app is recognized by `cargo-acap-build` as an ACAP app.
## * The app is installed on the device.
## * The app is stopped.
## * The device has SSH enabled the ssh user root configured.
run:
	cargo-acap-build --target $(AXIS_DEVICE_ARCH) -- -p $(AXIS_PACKAGE)
	acap-ssh-utils patch target/$(AXIS_DEVICE_ARCH)/$(AXIS_PACKAGE)/*.eap
	acap-ssh-utils run-app \
		--environment RUST_LOG=debug \
		--environment RUST_LOG_STYLE=always \
		$(AXIS_PACKAGE)

## Build and execute unit tests for app on <AXIS_DEVICE_IP> assuming architecture <AXIS_DEVICE_ARCH>
##
## Prerequisites:
##
## * app is recognized by `cargo-acap-build` as an ACAP app.
## * The app is installed on the device.
## * The app is stopped.
## * The device has SSH enabled the ssh user root configured.
test:
	# The `scp` command below needs the wildcard to match exactly one file.
	rm -r target/$(AXIS_DEVICE_ARCH)/$(AXIS_PACKAGE)-*/$(AXIS_PACKAGE) ||:
	cargo-acap-build --target $(AXIS_DEVICE_ARCH) -- -p $(AXIS_PACKAGE) --tests
	acap-ssh-utils patch target/$(AXIS_DEVICE_ARCH)/$(AXIS_PACKAGE)-*/*.eap
	acap-ssh-utils run-app \
		--environment RUST_LOG=debug \
		--environment RUST_LOG_STYLE=always \
		$(AXIS_PACKAGE) \
		-- \
		--test-threads=1

## Checks
## ------

## Run all other checks
check_all: check_build check_docs check_format check_lint
.PHONY: check_all

## Check that all crates can be built
check_build:
	cargo-acap-build --target aarch64
.PHONY: check_build

## Check that docs can be built
check_docs:
	RUSTDOCFLAGS="-Dwarnings" cargo doc \
		--document-private-items \
		--no-deps \
		--target aarch64-unknown-linux-gnu \
		--workspace
.PHONY: check_docs

## Check that the code is formatted correctly
check_format:
	cargo fmt --check
.PHONY: check_format

## Check that the code is free of lints
check_lint:
	cargo clippy \
		--all-targets \
		--no-deps \
		--target aarch64-unknown-linux-gnu \
		-- \
		-Dwarnings
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
