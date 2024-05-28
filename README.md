# Example app using [ACAP] and [Rust]

> [!IMPORTANT]
> This project is an experiment provided "as is".
> While we strive to maintain it, there's no guarantee of ongoing support, and it may become unmaintained in the future.
> Your contributions are appreciated, and feel free to fork and continue the journey if needed.

This is a template that can be used to create a new app using ACAP and Rust.
To contribute to the crates that this template uses, please see [acap-rs](https://github.com/AxisCommunications/acap-rs).

## Quickstart guide

Ensure global prerequisites are installed:

* Docker
* Rust e.g. [using rustup](https://www.rust-lang.org/tools/install)
* Cross e.g. like `cargo install cross`

Build the app and create `.eap` files in the `target/acap/` directory like

```sh
make build
```

Other useful workflows are documented under the "Verbs" section of the [Makefile](./Makefile).

## License

[MIT](LICENSE)

[ACAP]: https://axiscommunications.github.io/acap-documentation/
[Rust]: https://doc.rust-lang.org/
