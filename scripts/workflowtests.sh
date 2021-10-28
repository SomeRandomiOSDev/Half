#!/usr/bin/env bash
#
# workflowtests.sh
# Usage example: ./workflowtests.sh --no-clean

# Set Script Variables

SCRIPT="$("$(dirname "$0")/resolvepath.sh" "$0")"
SCRIPTS_DIR="$(dirname "$SCRIPT")"
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
CURRENT_DIR="$(pwd -P)"

EXIT_CODE=0
EXIT_MESSAGE=""

# Help

function printhelp() {
    local HELP="Run tests for the Github Action workflows.\n\n"
    HELP+="workflowtests.sh [--help | -h] [--project-name <project_name>]\n"
    HELP+="                 [--no-clean | --no-clean-on-fail]\n"
    HELP+="                 [--is-running-in-temp-env]\n"
    HELP+="\n"
    HELP+="--help, -h)               Print this help message and exit.\n"
    HELP+="\n"
    HELP+="--project-name)           The name of the project to run tests against. If not\n"
    HELP+="                          provided it will attempt to be resolved by searching\n"
    HELP+="                          the working directory for an Xcode project and using\n"
    HELP+="                          its name.\n"
    HELP+="\n"
    HELP+="--no-clean)               When not running in a temporary environment, do not\n"
    HELP+="                          clean up the temporary project created to run these\n"
    HELP+="                          tests upon completion.\n"
    HELP+="\n"
    HELP+="--no-clean-on-fail)       Same as --no-clean with the exception that if the\n"
    HELP+="                          succeed clean up will continue as normal. This is\n"
    HELP+="                          mutually exclusive with --no-clean with --no-clean\n"
    HELP+="                          taking precedence.\n"
    HELP+="\n"
    HELP+="--is-running-in-temp-env) Setting this flag tells this script that the\n"
    HELP+="                          environment (directory) in which it is running is a\n"
    HELP+="                          temporary environment and it need not worry about\n"
    HELP+="                          dirtying up the directory or creating/deleting files\n"
    HELP+="                          and folders. USE CAUTION WITH THIS OPTION.\n"
    HELP+="\n"
    HELP+="                          When this flag is NOT set, a copy of the containing\n"
    HELP+="                          working folder is created in a temporary location and\n"
    HELP+="                          removed (unless --no-clean is set) after the tests\n"
    HELP+="                          have finished running."

    IFS='%'
    echo -e $HELP 1>&2
    unset IFS

    exit $EXIT_CODE
}

# Parse Arguments

while [[ $# -gt 0 ]]; do
    case "$1" in
        --project-name)
        PROJECT_NAME="$2"
        shift # --project-name
        shift # <project_name>
        ;;

        --is-running-in-temp-env)
        IS_RUNNING_IN_TEMP_ENV=1
        shift # --is-running-in-temp-env
        ;;

        --no-clean)
        NO_CLEAN=1
        shift # --no-clean
        ;;

        --no-clean-on-fail)
        NO_CLEAN_ON_FAIL=1
        shift # --no-clean-on-fail
        ;;

        --help | -h)
        printhelp
        ;;

        *)
        echo -e "Unknown argument: $1\n" 1>&2
        EXIT_CODE=1
        printhelp
    esac
done

if [ -z ${IS_RUNNING_IN_TEMP_ENV+x} ]; then
    IS_RUNNING_IN_TEMP_ENV=0
fi

if [ -z ${NO_CLEAN+x} ]; then
    NO_CLEAN=0
fi

if [ -z ${NO_CLEAN_ON_FAIL+x} ]; then
    NO_CLEAN_ON_FAIL=0
fi

# Function Definitions

function cleanup() {
    cd "$CURRENT_DIR"

    if [ "$IS_RUNNING_IN_TEMP_ENV" == "0" ]; then
        if [[ "$NO_CLEAN" == "1" ]] || [[ "$NO_CLEAN_ON_FAIL" == "1" && "$EXIT_CODE" != "0" ]]; then
            echo "Test Project: $OUTPUT_DIR"
        elif [ "$OUTPUT_DIR" != "$ROOT_DIR" ]; then
            rm -rf "$OUTPUT_DIR"
        fi
    fi

    #

    local CARTHAGE_CACHE="$HOME/Library/Caches/org.carthage.CarthageKit"
    if [ -e "$CARTHAGE_CACHE" ]; then
        if [ -e "$CARTHAGE_CACHE/dependencies/$PROJECT_NAME" ]; then
            rm -rf "$CARTHAGE_CACHE/dependencies/$PROJECT_NAME"
        fi

        for DIR in $(find "$CARTHAGE_CACHE/DerivedData" -mindepth 1 -maxdepth 1 -type d); do
            if [ -e "$DIR/$PROJECT_NAME" ]; then
                rm -rf "$DIR/$PROJECT_NAME"
            fi
        done
    fi

    #

    if [ "${#EXIT_MESSAGE}" != 0 ]; then
        if [ "$EXIT_MESSAGE" == "**printhelp**" ]; then
            printhelp
        else
            echo -e "$EXIT_MESSAGE" 1>&2
        fi
    fi

    exit $EXIT_CODE
}

function checkresult() {
    if [ "$1" != "0" ]; then
        if [ "${#2}" != "0" ]; then
            EXIT_MESSAGE="\033[31m$2\033[0m"
        else
            EXIT_MESSAGE="**printhelp**"
        fi

        EXIT_CODE=$1
        cleanup
    fi
}

function printstep() {
    echo -e "\033[32m$1\033[0m"
}

function setuptemp() {
    local TEMP_DIR="$(dirname "$(mktemp -u)")"
    local OUTPUT_DIR="$(mktemp -d "${TEMP_DIR}/${PROJECT_NAME}WorkflowTests-XXXXXXXX")"

    cp -R "${ROOT_DIR%/}/" "$OUTPUT_DIR"
    if [ "$?" != "0" ]; then exit $?; fi

    if [ -e "$OUTPUT_DIR/.build" ]; then
        rm -rf "$OUTPUT_DIR/.build"
    fi
    if [ -e "$OUTPUT_DIR/.swiftpm" ]; then
        rm -rf "$OUTPUT_DIR/.swiftpm"
    fi

    echo "$OUTPUT_DIR"
}

function interrupt() {
    EXIT_CODE=$SIGINT
    EXIT_MESSAGE="\033[33mTests run was interrupted..\033[0m"

    cleanup
}

# Setup

trap interrupt SIGINT # Cleanup if the user aborts (Ctrl + C)

#

ARGUMENTS=()
if [ "${#PROJECT_NAME}" != 0 ]; then
    ARGUMENTS=(--project-name "$PROJECT_NAME")
fi

PROJECT_NAME="$("$SCRIPTS_DIR/findproject.sh" "${ARGUMENTS[@]}")"
checkresult $?

#

if [ "$IS_RUNNING_IN_TEMP_ENV" == "1" ]; then
    OUTPUT_DIR="$ROOT_DIR"
else
    OUTPUT_DIR="$(setuptemp)"
    echo -e "Testing from Temporary Directory: \033[33m$OUTPUT_DIR\033[0m"
fi

# Check For Dependencies

cd "$OUTPUT_DIR"
printstep "Checking for Test Dependencies..."

### Carthage

if which carthage >/dev/null; then
    CARTHAGE_VERSION="$(carthage version)"
    echo "Carthage: $CARTHAGE_VERSION"

    "$SCRIPTS_DIR/versions.sh" "$CARTHAGE_VERSION" "0.37.0"

    if [ $? -lt 0 ]; then
        echo -e "\033[33mCarthage version of at least 0.37.0 is recommended for running these unit tests\033[0m"
    fi
else
    checkresult -1 "Carthage is not installed and is required for running unit tests: \033[4;34mhttps://github.com/Carthage/Carthage#installing-carthage"
fi

### CocoaPods

if which pod >/dev/null; then
    PODS_VERSION="$(pod --version)"
    "$SCRIPTS_DIR/versions.sh" "$PODS_VERSION" "1.7.3"

    if [ $? -ge 0 ]; then
        echo "CocoaPods: $(pod --version)"
    else
        checkresult -1 "These unit tests require version 1.7.3 or later of CocoaPods: \033[4;34mhttps://guides.cocoapods.org/using/getting-started.html#updating-cocoapods"
    fi
else
    checkresult -1 "CocoaPods is not installed and is required for running unit tests: \033[4;34mhttps://guides.cocoapods.org/using/getting-started.html#installation"
fi

# Run Tests

printstep "Running Tests..."

### Carthage Workflow

printstep "Testing 'carthage.yml' Workflow..."

git add .
git commit -m "Commit" --no-gpg-sign
git tag | xargs git tag -d
git tag --no-sign 1.0
checkresult $? "'Create Cartfile' step of 'carthage.yml' workflow failed."

echo "git \"file://$OUTPUT_DIR\"" > ./Cartfile

./scripts/carthage.sh update
checkresult $? "'Build' step of 'carthage.yml' workflow failed."

printstep "'carthage.yml' Workflow Tests Passed\n"

### CocoaPods Workflow

printstep "Testing 'cocoapods.yml' Workflow..."

pod lib lint
checkresult $? "'Lint (Dynamic Library)' step of 'cocoapods.yml' workflow failed."

pod lib lint --use-libraries
checkresult $? "'Lint (Static Library)' step of 'cocoapods.yml' workflow failed."

printstep "'cocoapods.yml' Workflow Tests Passed\n"

### Swift Package Workflow

printstep "Testing 'swift-package.yml' Workflow..."

swift build -v
checkresult $? "'Build' step of 'swift-package.yml' workflow failed."

swift test -v --enable-code-coverage
checkresult $? "'Test' step of 'swift-package.yml' workflow failed."

xcrun llvm-cov export --format=lcov --instr-profile=".build/debug/codecov/default.profdata" ".build/debug/${PROJECT_NAME}PackageTests.xctest/Contents/MacOS/${PROJECT_NAME}PackageTests" > "./codecov.lcov"
checkresult $? "'Generate Code Coverage File' step of 'swift-package.yml' workflow failed."

printstep "'swift-package.yml' Workflow Tests Passed\n"

### XCFramework Workflow

printstep "Testing 'xcframework.yml' Workflow..."

./scripts/xcframework.sh --project-name "$PROJECT_NAME" --output "$OUTPUT_DIR"
checkresult $? "'Build' step of 'xcframework.yml' workflow failed."

printstep "'xcframework.yml' Workflow Tests Passed\n"

### Upload Assets Workflow

printstep "Testing 'upload-assets.yml' Workflow..."

zip -rX "$PROJECT_NAME.xcframework.zip" "$PROJECT_NAME.xcframework"
checkresult $? "'Create Zip' step of 'upload-assets.yml' workflow failed."

tar -zcvf "$PROJECT_NAME.xcframework.tar.gz" "$PROJECT_NAME.xcframework"
checkresult $? "'Create Tar' step of 'upload-assets.yml' workflow failed."

printstep "'upload-assets.yml' Workflow Tests Passed\n"

### Xcodebuild Workflow

printstep "Testing 'xcodebuild.yml' Workflow..."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME" -destination "generic/platform=iOS" -configuration Debug
checkresult $? "'Build iOS' step of 'xcodebuild.yml' workflow failed."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME" -destination "generic/platform=iOS Simulator" -configuration Debug
checkresult $? "'Build iOS Simulator' step of 'xcodebuild.yml' workflow failed."

IOS_SIM="$(xcrun simctl list devices available | grep "iPhone [0-9]" | sort -rV | head -n 1 | sed -E 's/(.+)[ ]*\([^)]*\)[ ]*\([^)]*\)/\1/' | awk '{$1=$1};1')"

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME" -testPlan "${PROJECT_NAME}Tests" -destination "platform=iOS Simulator,name=$IOS_SIM" -configuration Debug ONLY_ACTIVE_ARCH=YES test
checkresult $? "'Test iOS' step of 'xcodebuild.yml' workflow failed."

###

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME" -destination "generic/platform=macOS,variant=Mac Catalyst" -configuration Debug
checkresult $? "'Build MacCatalyst' step of 'xcodebuild.yml' workflow failed."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME" -testPlan "${PROJECT_NAME}Tests" -destination "platform=macOS,variant=Mac Catalyst" -configuration Debug ONLY_ACTIVE_ARCH=YES test
checkresult $? "'Test MacCatalyst' step of 'xcodebuild.yml' workflow failed."

###

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME macOS" -destination "generic/platform=macOS" -configuration Debug
checkresult $? "'Build macOS' step of 'xcodebuild.yml' workflow failed."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME macOS" -testPlan "$PROJECT_NAME macOS Tests" -configuration Debug ONLY_ACTIVE_ARCH=YES test
checkresult $? "'Test macOS' step of 'xcodebuild.yml' workflow failed."

###

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME tvOS" -destination "generic/platform=tvOS" -configuration Debug
checkresult $? "'Build tvOS' step of 'xcodebuild.yml' workflow failed."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME tvOS" -destination "generic/platform=tvOS Simulator" -configuration Debug
checkresult $? "'Build tvOS Simulator' step of 'xcodebuild.yml' workflow failed."

TVOS_SIM="$(xcrun simctl list devices available | grep "Apple TV" | sort -V | head -n 1 | sed -E 's/(.+)[ ]*\([^)]*\)[ ]*\([^)]*\)/\1/' | awk '{$1=$1};1')"

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME tvOS" -testPlan "$PROJECT_NAME tvOS Tests" -destination "platform=tvOS Simulator,name=$TVOS_SIM" -configuration Debug ONLY_ACTIVE_ARCH=YES test
checkresult $? "'Test tvOS' step of 'xcodebuild.yml' workflow failed."

###

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME watchOS" -destination "generic/platform=watchOS" -configuration Debug
checkresult $? "'Build watchOS' step of 'xcodebuild.yml' workflow failed."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME watchOS" -destination "generic/platform=watchOS Simulator" -configuration Debug
checkresult $? "'Build watchOS Simulator' step of 'xcodebuild.yml' workflow failed."

WATCHOS_SIM="$(xcrun simctl list devices available | grep "Apple Watch" | sort -rV | head -n 1 | sed -E 's/(.+)[ ]*\([^)]*\)[ ]*\([^)]*\)/\1/' | awk '{$1=$1};1')"

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME watchOS" -testPlan "$PROJECT_NAME watchOS Tests" -destination "platform=watchOS Simulator,name=$WATCHOS_SIM" -configuration Debug ONLY_ACTIVE_ARCH=YES test
checkresult $? "'Test watchOS' step of 'xcodebuild.yml' workflow failed."

printstep "'xcodebuild.yml' Workflow Tests Passed\n"

### Test Schemes

printstep "Testing running unit tests using test schemes..."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "${PROJECT_NAME}Tests" -testPlan "${PROJECT_NAME}Tests" -destination "platform=iOS Simulator,name=$IOS_SIM" -configuration Debug ONLY_ACTIVE_ARCH=YES test
checkresult $? "Test iOS (Test Scheme) failed."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "${PROJECT_NAME}Tests" -testPlan "${PROJECT_NAME}Tests" -destination "platform=macOS,variant=Mac Catalyst" -configuration Debug ONLY_ACTIVE_ARCH=YES test
checkresult $? "Test MacCatalyst (Test Scheme) failed."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME macOS Tests" -testPlan "$PROJECT_NAME macOS Tests" -configuration Debug ONLY_ACTIVE_ARCH=YES test
checkresult $? "Test macOS (Test Scheme) failed."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME tvOS Tests" -testPlan "$PROJECT_NAME tvOS Tests" -destination "platform=tvOS Simulator,name=$TVOS_SIM" -configuration Debug ONLY_ACTIVE_ARCH=YES test
checkresult $? "Test tvOS (Test Scheme) failed."

xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME watchOS Tests" -testPlan "$PROJECT_NAME watchOS Tests" -destination "platform=watchOS Simulator,name=$WATCHOS_SIM" -configuration Debug ONLY_ACTIVE_ARCH=YES test
checkresult $? "Test watchOS (Test Scheme) failed."

printstep "Test Scheme Unit Tests Passed\n"

### Success

cleanup
