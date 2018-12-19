# Area51
Open source Reddit client for iOS built entirely in Swift
---

# Goal

Provide a fun learning environment which is easy to setup!

# Building Project

Clone the repo and rung the generate command
```console
git clone git@github.com:kgellci/Area51.git
cd Area51/
make generate
```

After `generate` is finished doing its job, open Area51.xcodeproj, build and run.

## Running on a device
Create user.xcconfig file in Configs/ directory
Set `DEVELOPMENT_TEAM` in the user.xcconfig file. Example:
`DEVELOPMENT_TEAM = XXXXXXXXX`

You will need to close the xcode project, run `make generate, open the project back up.
You can find your team ID by logging into developer.apple.com

# License
Area51 is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for more info.
