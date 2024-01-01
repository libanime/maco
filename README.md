# maco

![coverage][coverage_badge]
[![License: MIT][license_badge]][license_link]
[![License: pub][pub_badge]][pub_link]

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=libanime&repo=maco)](https://github.com/libanime/maco/)


An anime downloading cli based on [libanime](https://github.com/libanime/libanime).

---

## Getting Started 🚀

If the CLI application is available on [pub](https://pub.dev), activate globally via:

```sh
dart pub global activate maco
```

Or locally via:

```sh
dart pub global activate --source=path <path to this package>
```

Also you can use portable version in Releases page.

## Usage

```sh
# Parse direct mp4 url for kodik player and download.
$ maco kodik -u //kodik.info/seria/428055/cf7b8847a36a6904743111e46c2b77d1/720p -d

# Parse direct mp4 url for sibnet player.
$ maco sibnet -u https://video.sibnet.ru/shell.php?videoid=2235917

# Show CLI version
$ maco --version

# Show usage help
$ maco --help
```

## Running Tests with coverage 🧪

To run all unit tests use the following command:

```sh
$ dart pub global activate coverage 1.2.0
$ dart test --coverage=coverage
$ dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov)
.

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

[coverage_badge]: https://github.com/libanime/maco/raw/stable/coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[pub_badge]: https://img.shields.io/pub/v/maco.svg
[pub_link]: https://pub.dev/packages/maco