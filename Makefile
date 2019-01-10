generate:
	touch ./Configs/user.xcconfig
	@./scripts/setup-bundle-id.sh
	@./scripts/ensure-xcodegen.sh
	@./scripts/ensure-swiftlint.sh
	./tmp/XcodeGen

lint:
	@./scripts/ensure-swiftlint.sh
	./tmp/SwiftLint
