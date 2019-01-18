<img src="/docs/resources/A51Icon.png" width="144" alt="Area51 App Icon">

# Area51

[![Build Status](https://travis-ci.org/kgellci/Area51.svg?branch=master)](https://travis-ci.org/kgellci/Area51)

Area51 is an open source Reddit client for iOS built entirely in Swift!

[**Get the public beta on TestFlight**](https://testflight.apple.com/join/V6vpApGX)

[**Join the public Slack channel to collaborate!**](https://join.slack.com/t/area51os/shared_invite/enQtNTE3NDM1NTc4NzcyLWZkMjkxMjA0ODA0ZTFjMTc4MzBmMjg3NDc4YjVmZjg0ZjI2MTkxOWE4YjAzNmU2ZTllMTBkZmUyZjU0OGM5OWI)

## Goals

- Provide a beginner friendly development environment
- Use the latest iOS development tools
- Document everything! Helps beginners learn :)
- Build an awesome open source Reddit client for iOS!

## Getting Started

### Requirements

Make sure you have Xcode: 10.1 or higher.

This project currently supports Swift 4.2+

### Setup

Clone the repo and run the generate command:
```console
git clone git@github.com:kgellci/Area51.git
cd Area51/
make generate
```

After `generate` is finished doing its job, open Area51.xcodeproj, build and run.

### Project Structure

Area51 does not import any 3rd party libraries in app.

[Xcodegen](https://github.com/yonaskolb/XcodeGen) is used for project definition and generation.

[Swiftlint](https://github.com/realm/SwiftLint) is used to keep the code properly structured and readable.

[Learn more about the project structure.](docs/project.md)

### Running on a device
Make sure you run `make generate` command from above to generate the appropriate config files.

Edit the `user.xcconfig` file in the `Configs/` directory (don't worry, it is gitignored!).
Set `DEVELOPMENT_TEAM` in the user.xcconfig file. Example:
`DEVELOPMENT_TEAM = XXXXXXXXX`

Edit the `bundleIdentifier.xcconfig` file in `Configs/` directory (also gitignored!).
Set `PRODUCT_BUNDLE_IDENTIFIER` in bundleIdentifier.xcconfig to something unique, Example:
`PRODUCT_BUNDLE_IDENTIFIER = whatever.i.want`

You will need to close the Xcode project, run `make generate` and open the project again.
You can find your team ID by logging into [developer.apple.com](developer.apple.com).

# FAQ
If you have more questions, check out the [FAQ](docs/faq.md). If your question is not answered, open a new issue with the "Question" tag.

# License
Area51 is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for more info.
