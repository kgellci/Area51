# Frequently Asked Questions

## Why do I have to run `make generate` in the beginning?

Most software projects use add-ons and libraries to make development easier (one popular add-on for package management in the iOS development world is **[Cocoapods](http://cocoapods.org)**). Using package managers makes working with 3rd-party libraries easier. Projects like this normally require additional setup and or configuration.

To save time, the setup and build process is usually automated. This project uses **[GNU Make](https://www.gnu.org/software/make/)**. At the time of writing the setup chain defines the following [rules](https://www.gnu.org/software/make/manual/html_node/Makefile-Contents.html#Makefile-Contents) that do the following things (defined in the [Makefile](https://github.com/kgellci/Area51/blob/master/Makefile)):

1. Rule: `generate`
    - Creates a `user.xconfig` file that allows different developers to enter their individual configurations (it's gitignored)
    - Runs two scripts (`ensure-xcodegen.sh`, `ensure-swiftlint.sh`) that installs a specified version of Xcodegen and Swiftlint respectively. The scripts download the appropriate version, if they are not available
    - Runs Xcodegen

2. Rule: `lint`
    - Runs a script
    - Runs SwiftLint

The Area51 team uses **[XcodeGen](https://github.com/yonaskolb/XcodeGen)** to generate the `Area51.xcodeproj` file to make sure there are no merge conflicts when multiple developers are adding files. And **[SwiftLint](https://github.com/realm/SwiftLint)** to enforce a code style which is standard across many companies.

## The project uses Xcodegen, but instead of `xcodegen generate` it uses `make generate`. Why?

Even though the `generate` command sounds similar, they are different here:

- `make generate` executes a `make` _rule_ called `generate` (see the [Makefile](https://github.com/kgellci/Area51/blob/master/Makefile)).
- `xcodegen generate` executes the program `xcodegen` with the subcommand `generate`

## Where do I start reading the code, if I am a beginner?

The control flow is as follows:

- Once the app starts (eg tapping on the icon), iOS calls the `AppDelegate.swift`.
- In Area51 this tells the `NavigationRouter.swift` to load.
- The NavigationRouter instantiates the tabs (at the time of writing the feedController and the settingsController) and sets them up in the tab bar at the bottom.
- Bot controllers get added into an array of controllers and iOS presents the item in the first position in this array.
- In the case of Area51 the feedController itself already does some things (like opening a subreddit). You can checkout the code for that in the `FeedViewController.swift`