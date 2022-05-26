//
//  AXErrorTests.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import XCTest
@testable import AX

@available(macOS 10.3, *)
final class AXErrorTests: XCTestCase {
    func testSuccessError() throws {
        try ApplicationServices.AXError.success.check()
    }
    func testKnownError() throws {
        XCTAssertThrowsError(try ApplicationServices.AXError.notificationUnsupported.check())
    }
    func testUnknownError() throws {
        let unknownError = ApplicationServices.AXError(rawValue: 1)
        XCTAssertNotNil(unknownError)
        XCTAssertThrowsError(try unknownError!.check())
    }
    func testSuccessErrorWithReturnValue() throws {
        let input: String? = ""
        let output = try ApplicationServices.AXError.success.check(input)
        XCTAssertEqual(input, output)
    }
    func testKnownErrorWithReturnValue() throws {
        let input: String? = nil
        XCTAssertThrowsError(try ApplicationServices.AXError.notificationUnsupported.check(input))
    }
    func testUnknownErrorWithReturnValue() throws {
        let unknownError = ApplicationServices.AXError(rawValue: 1)
        XCTAssertNotNil(unknownError)
        let input: String? = nil
        XCTAssertThrowsError(try unknownError!.check(input))
    }
}
