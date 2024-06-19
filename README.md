# Example app using ACAP and Rust

> [!IMPORTANT]
> This project is an experiment provided "as is".
> While we strive to maintain it, there's no guarantee of ongoing support, and it may become unmaintained in the future.
> Your contributions are appreciated, and feel free to fork and continue the journey if needed.

This is a template that can be used to create a new app using [Axis Camera Application Platform (ACAP)](https://axiscommunications.github.io/acap-documentation/) and Rust.
To contribute to the crates that this template uses, please see [acap-rs](https://github.com/AxisCommunications/acap-rs).

## Quickstart guide

Build the `hello_world` example and create `.eap` files in the `target/acap/` directory like

```sh
docker build --tag acap-rs-app-template .
docker run \
  --interactive \
  --rm \
  --tty \
  --user $(id -u):$(id -g) \
  --volume $(pwd):$(pwd) \
  --workdir $(pwd) \
  acap-rs \
  make build PACKAGE=hello_world
```

This works with any of the [example applications](#example-applications).

## Advanced setup

Ensure global prerequisites are installed:

* Docker
* Rust e.g. [using rustup](https://www.rust-lang.org/tools/install)
* Cross e.g. like `cargo install cross`

Useful workflows are documented under the "Verbs" section of the [Makefile](./Makefile).
If Python package `mkhelp==0.2.1` is installed, they can be summarized like:

```console
$ mkhelp print-docs Makefile help
Verbs:
   build: Build app for all architectures
 install: Install app on <DEVICE_IP> using password <PASS> and assuming architecture <ARCH>
  remove: Remove app from <DEVICE_IP> using password <PASS> and assuming architecture <ARCH>
   start: Start app on <DEVICE_IP> using password <PASS> and assuming architecture <ARCH>
    stop: Stop app on <DEVICE_IP> using password <PASS> and assuming architecture <ARCH>
     run: Build and run app directly on <DEVICE_IP> assuming architecture <ARCH>

Checks:
    check_all: Run all other checks
  check_build: Check that all crates can be built
   check_docs: Check that docs can be built
 check_format: Check that the code is formatted correctly
   check_lint: Check that the code is free of lints

Fixes:
 fix_format: Attempt to fix formatting automatically
   fix_lint: Attempt to fix lints automatically
```

## Troubleshooting

The docker image may fail to build with the following included in the output:
`/usr/bin/env: 'sh\r': No such file or directory`
This is likely caused by `git` replacing POSIX newlines with Windows newlines in which case it can be resolved by either
- cloning the code in Windows Subsystem for Linux (WSL), or
- reconfiguring `git`.

## License

[MIT](LICENSE)
