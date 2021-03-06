WORKSPACE=ContentfulSDK.xcworkspace

.PHONY: all clean doc example example-static pod really-clean static-lib test

clean:
	rm -rf build Examples/UFO/build Examples/*.zip compile_commands.json .gutter.json
	rm -rf Examples/UFO/Distribution/ContentfulDeliveryAPI.framework

really-clean: clean
	rm -rf Pods $(HOME)/Library/Developer/Xcode/DerivedData/*

all: test example-static

pod:
	bundle exec pod install

example:
	set -o pipefail && xcodebuild clean build -workspace $(WORKSPACE) \
		-scheme ContentfulDeliveryAPI \
		-sdk iphonesimulator | xcpretty -c
	set -o pipefail && xcodebuild clean build -workspace $(WORKSPACE) \
		-scheme 'UFO Example' \
		-sdk iphonesimulator | xcpretty -c

example-static: static-lib
	cd Examples/UFO; set -o pipefail && xcodebuild clean build \
		-sdk iphonesimulator | xcpretty -c

static-lib:
	bundle exec pod repo update >/dev/null
	bundle exec pod package ContentfulDeliveryAPI.podspec

	@cd Examples/UFO/Distribution; ./update.sh
	cd Examples; ./ship_it.sh

	rm -rf ContentfulDeliveryAPI-*/

test: example
	@osascript -e 'tell app "iOS Simulator" to quit'
	@osascript -e 'tell app "Simulator" to quit'
	bundle exec pod lib coverage

lint:
	set -o pipefail && xcodebuild clean build -workspace $(WORKSPACE) -dry-run \
		-scheme ContentfulDeliveryAPI \
		-sdk iphonesimulator clean build|xcpretty -r json-compilation-database \
		-o compile_commands.json
	oclint-json-compilation-database

doc:
	bundle exec pod lib docstats
