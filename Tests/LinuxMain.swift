import XCTest

import CHalfTests
import HalfTests

var tests = [XCTestCaseEntry]()
tests += CHalfTests.__allTests()
tests += HalfTests.__allTests()

XCTMain(tests)
