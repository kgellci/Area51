generate:
	touch ./Configs/user.xcconfig
	@./scripts/setup-bundle-id.sh
	@./scripts/ensure-xcodegen.sh
	@./scripts/ensure-swiftlint.sh
	./tmp/XcodeGen

lint:
	@./scripts/ensure-swiftlint.sh
	./tmp/SwiftLint

# List the test schemes in the project
TEST_SCHEMES = CoreTests CoreAPITests

# Loop through each test scheme and run the tests
test:
	@(for scheme in $(TEST_SCHEMES) ; do \
		xcodebuild test -quiet -project Area51.xcodeproj -scheme "$${scheme}" -destination 'name=iPhone X'; \
	done)
