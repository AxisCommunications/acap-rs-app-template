# Example app using ACAP and Rust

> [!IMPORTANT]
> This project is an experiment provided "as is".
> While we strive to maintain it, there's no guarantee of ongoing support, and it may become unmaintained in the future.
> Your contributions are appreciated, and feel free to fork and continue the journey if needed.

This is a template that can be used to create a new app using [Axis Camera Application Platform (ACAP)](https://axiscommunications.github.io/acap-documentation/) and Rust.
To contribute to the crates that this template uses, please see [acap-rs](https://github.com/AxisCommunications/acap-rs).

## Quickstart guide

Ensure global prerequisites are installed:

* Docker
* Rust e.g. [using rustup](https://www.rust-lang.org/tools/install)
* `cargo-acap-sdk` like `cargo install --git https://github.com/AxisCommunications/acap-rs.git --rev 452583a5898e233ec3e2a391923b8971fe7f342b cargo-acap-sdk`

Build the app and create `.eap` files in the `target/acap/` directory like:

```sh
make build
```

Other useful workflows are documented under the "Verbs" section of the [Makefile](./Makefile).
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
    test: Build and execute unit tests on <DEVICE_IP> assuming architecture <ARCH>

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

Yet more useful workflows can be listed like

```console
$ cargo-acap-sdk help
ACAP analog to `cargo` for building and deploying apps

Usage: cargo-acap-sdk <COMMAND>

Commands:
  build         Build app(s)
  run           Build executable for app(s) and run on the device, impersonating a user or the app
  test          Build test(s) and run on the device, impersonating a user or the app
  install       Build app(s) and install on the device
  start         TODO: Implement; Start app(s) on the device
  stop          TODO: Implement; Stop app(s) on the device
  uninstall     TODO: Implement; Uninstall app(s) on the device
  containerize  Run the provided program in a container
  completions   Print shell completion script for this program
  help          Print this message or the help of the given subcommand(s)

Options:
  -h, --help     Print help
  -V, --version  Print version
```

Note that the shell completions may not work when using the program as a cargo plugin like
`cargo acap-sdk` (note the difference between ` ` and `-`).

## License

[MIT](LICENSE)
