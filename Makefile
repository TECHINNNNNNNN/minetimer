APP=minetimer
BUILD=build

.PHONY: gen build run test release clean

gen:
	xcodegen generate -q

build: gen
	xcodebuild -project $(APP).xcodeproj -scheme $(APP) -configuration Debug \
	  -derivedDataPath $(BUILD) build 2>&1 | grep -E "error:|BUILD" || true

run: build
	pkill -x $(APP) || true
	open $(BUILD)/Build/Products/Debug/$(APP).app

test: gen
	xcodebuild -project $(APP).xcodeproj -scheme $(APP) -derivedDataPath $(BUILD) test 2>&1 \
	  | grep -E "error:|Test Suite|passed|failed|TEST" || true

release: gen
	xcodebuild -project $(APP).xcodeproj -scheme $(APP) -configuration Release \
	  -derivedDataPath $(BUILD) build 2>&1 | grep -E "error:|BUILD" || true
	cd $(BUILD)/Build/Products/Release && zip -qr -y ../../../../$(APP).zip $(APP).app

clean:
	rm -rf $(BUILD) $(APP).xcodeproj $(APP).zip
