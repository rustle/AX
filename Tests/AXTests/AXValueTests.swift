//
//  AXValueTests.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import XCTest
@testable import AX

final class AXValueTests: XCTestCase {
    func testPoint() throws {
        var cgPoint = CGPoint(x: 1,
                              y: 2)
        let axValue = AXValueCreate(.cgPoint,
                                    &cgPoint)!
        let value = try Value(value: axValue)
        XCTAssertEqual(value,
                       Value.point(cgPoint))
        XCTAssertEqual(value.value,
                       axValue)
    }
    func testSize() throws {
        var cgSize = CGSize(width: 1,
                            height: 2)
        let axValue = AXValueCreate(.cgSize,
                                    &cgSize)!
        let value = try Value(value: axValue)
        XCTAssertEqual(value,
                       Value.size(cgSize))
        XCTAssertEqual(value.value,
                       axValue)
    }
    func testRect() throws {
        var cgRect = CGRect(x: 1,
                            y: 2,
                            width: 3,
                            height: 4)
        let axValue = AXValueCreate(.cgRect,
                                    &cgRect)!
        let value = try Value(value: axValue)
        XCTAssertEqual(value,
                       Value.rect(cgRect))
        XCTAssertEqual(value.value,
                       axValue)
    }
    func testRange() throws {
        var cfRange = CFRange(location: 1,
                              length: 2)
        let axValue = AXValueCreate(.cfRange,
                                    &cfRange)!
        let value = try Value(value: axValue)
        XCTAssertEqual(value,
                       Value.range(cfRange.location..<cfRange.location+cfRange.length))
        XCTAssertEqual(value.value,
                       axValue)
    }
    func testError() throws {
        var axError = AXError.illegalArgument
        let axValue = AXValueCreate(.axError,
                                    &axError)!
        let value = try Value(value: axValue)
        XCTAssertEqual(value,
                       .error(Error.illegalArgument))
        XCTAssertEqual(value.value,
                       axValue)
    }
}
