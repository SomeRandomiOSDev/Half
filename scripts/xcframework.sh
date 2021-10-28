#!/usr/bin/env bash
#
# xcframework.sh
# Usage example: ./xcframework.sh -output <some_path>/<name>.xcframework

# Set Script Variables

SCRIPT="$("$(dirname "$0")/resolvepath.sh" "$0")"
SCRIPTS_DIR="$(dirname "$SCRIPT")"
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
CURRENT_DIR="$(pwd -P)"

EXIT_CODE=0

# Help

function printhelp() {
    local HELP="Builds an XCFramework for the given project.\n\n"
    HELP+="xcframework.sh [--help | -h] [--output (<output_framework> |\n"
    HELP+="               <output_folder>)] [--configuration <configuration>]\n"
    HELP+="               [--project-name <project_name>]\n"
    HELP+="\n"
    HELP+="--help, -h)      Print this help message and exit.\n"
    HELP+="\n"
    HELP+="--output)        The directory or fully qualified path to export the generated\n"
    HELP+="                 XCFramework to. If not specified, this defaults to\n"
    HELP+="                 \"<scripts_dir>/build/<project_name>.xcframework\"\n"
    HELP+="\n"
    HELP+="--configuration) The configuration to use when building each scheme. This is\n"
    HELP+="                 passed directly to `xcodebuild` without modification. If not\n"
    HELP+="                 specified, this defaults to \"Release\".\n"
    HELP+="\n"
    HELP+="--project-name)  The name of the project to run tests against. If not provided\n"
    HELP+="                 it will attempt to be resolved by searching the working\n"
    HELP+="                 directory for an Xcode project and using its name.\n"

    IFS='%'
    echo -e $HELP 1>&2
    unset IFS

    exit $EXIT_CODE
}

# Parse Arguments

while [[ $# -gt 0 ]]; do
    case "$1" in
        --output)
        OUTPUT="$2"
        shift # --output
        shift # <project_name>
        ;;

        --configuration)
        CONFIGURATION="$2"
        shift # --configuration
        shift # <configuration>
        ;;

        --project-name)
        PROJECT_NAME="$2"
        shift # --project-name
        shift # <project_name>
        ;;

        --help | -h)
        printhelp
        ;;

        *)
        echo "Unknown argument: $1" 1>&2
        EXIT_CODE=1
        printhelp
    esac
done

#

ARGUMENTS=()
if [ "${#PROJECT_NAME}" != 0 ]; then
    ARGUMENTS=(--project-name "$PROJECT_NAME")
fi

PROJECT_NAME="$("$SCRIPTS_DIR/findproject.sh" "${ARGUMENTS[@]}")"
EXIT_CODE=$?

if [ "$EXIT_CODE" != "0" ]; then
    printhelp
fi

#

if [ -z ${OUTPUT+x} ]; then
    OUTPUT="$SCRIPTS_DIR/build/$PROJECT_NAME.xcframework"
elif [ "${OUTPUT##*.}" != "xcframework" ]; then
    if [ "${OUTPUT: -1}" == "/" ]; then
        OUTPUT="${OUTPUT}${PROJECT_NAME}.xcframework"
    else
        OUTPUT="${OUTPUT}/${PROJECT_NAME}.xcframework"
    fi
fi

if [ -z ${CONFIGURATION+x} ]; then
    CONFIGURATION="Release"
fi

# Create Temporary Directory

TMPDIR=`mktemp -d /tmp/.$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]').xcframework.build.XXXXXX`
cd "$ROOT_DIR"

check_result() {
    if [ "$1" != "0" ]; then
        rm -rf "${TMPDIR}"
        exit $1
    fi
}

# Build iOS
xcodebuild -project "${PROJECT_NAME}.xcodeproj" -scheme "${PROJECT_NAME}" -destination "generic/platform=iOS" -archivePath "${TMPDIR}/iphoneos.xcarchive" -configuration ${CONFIGURATION} SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="armv7 armv7s arm64 arm64e" archive
check_result $?

# Build iOS Simulator
xcodebuild -project "${PROJECT_NAME}.xcodeproj" -scheme "${PROJECT_NAME}" -destination "generic/platform=iOS Simulator" -archivePath "${TMPDIR}/iphonesimulator.xcarchive" -configuration ${CONFIGURATION} SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="i386 x86_64 arm64" archive
check_result $?

# Build Mac Catalyst
xcodebuild -project "${PROJECT_NAME}.xcodeproj" -scheme "${PROJECT_NAME}" -destination "generic/platform=macOS,variant=Mac Catalyst" -archivePath "${TMPDIR}/maccatalyst.xcarchive" -configuration ${CONFIGURATION} SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="x86_64 arm64 arm64e" archive
check_result $?

# Build Mac
xcodebuild -project "${PROJECT_NAME}.xcodeproj" -scheme "${PROJECT_NAME} macOS" -destination "generic/platform=macOS" -archivePath "${TMPDIR}/macos.xcarchive" -configuration ${CONFIGURATION} SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="x86_64 arm64 arm64e" archive
check_result $?

# Build tvOS
xcodebuild -project "${PROJECT_NAME}.xcodeproj" -scheme "${PROJECT_NAME} tvOS" -destination "generic/platform=tvOS" -archivePath "${TMPDIR}/appletvos.xcarchive" -configuration ${CONFIGURATION} SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="arm64 arm64e" archive
check_result $?

# Build tvOS Simulator
xcodebuild -project "${PROJECT_NAME}.xcodeproj" -scheme "${PROJECT_NAME} tvOS" -destination "generic/platform=tvOS Simulator" -archivePath "${TMPDIR}/appletvsimulator.xcarchive" -configuration ${CONFIGURATION} SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="x86_64 arm64" archive
check_result $?

# Build watchOS
xcodebuild -project "${PROJECT_NAME}.xcodeproj" -scheme "${PROJECT_NAME} watchOS" -destination "generic/platform=watchOS" -archivePath "${TMPDIR}/watchos.xcarchive" -configuration ${CONFIGURATION} SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="arm64_32 armv7k" archive
check_result $?

# Build watchOS Simulator
xcodebuild -project "${PROJECT_NAME}.xcodeproj" -scheme "${PROJECT_NAME} watchOS" -destination "generic/platform=watchOS Simulator" -archivePath "${TMPDIR}/watchsimulator.xcarchive" -configuration ${CONFIGURATION} SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="i386 x86_64 arm64" archive
check_result $?

# Make XCFramework

if [[ -d "${OUTPUT}" ]]; then
    rm -rf "${OUTPUT}"
fi

ARGUMENTS=(-create-xcframework -output "${OUTPUT}")

for ARCHIVE in ${TMPDIR}/*.xcarchive; do
    ARGUMENTS=(${ARGUMENTS[@]} -framework "${ARCHIVE}/Products/Library/Frameworks/${PROJECT_NAME}.framework")

    if [[ -d "${ARCHIVE}/dSYMs/${PROJECT_NAME}.framework.dSYM" ]]; then
        ARGUMENTS=(${ARGUMENTS[@]} -debug-symbols "${ARCHIVE}/dSYMs/${PROJECT_NAME}.framework.dSYM")
    fi

    if [[ -d "${ARCHIVE}/BCSymbolMaps" ]]; then
        for SYMBOLMAP in ${ARCHIVE}/BCSymbolMaps/*.bcsymbolmap; do
            ARGUMENTS=(${ARGUMENTS[@]} -debug-symbols "${SYMBOLMAP}")
        done
    fi
done

xcodebuild "${ARGUMENTS[@]}"
check_result $?

# Cleanup

rm -rf "${TMPDIR}"
exit 0
