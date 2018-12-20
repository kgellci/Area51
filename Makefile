generate:
	touch ./Configs/user.xcconfig
	@./scripts/ensure-xcodegen.sh
	@./scripts/ensure-swiftlint.sh
	./tmp/XcodeGen

lint:
	@./scripts/ensure-swiftlint.sh
	./tmp/SwiftLint
