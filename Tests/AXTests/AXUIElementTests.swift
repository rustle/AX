//
//  AXUIElementTests.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import XCTest
@testable import AX
import dyldoverlay
import Cocoa

@available(macOS 10.0, *)
final class AXUIElementTests: XCTestCase {
    func testApplicationUIElementCast() throws {
        let axUIElement = AXUIElementCreateApplication(10)
        XCTAssertEqual(try (axUIElement as UIElement).pid, 10)
    }
    func testUIElementEqualityWithCasting() throws {
        let CreateWithDataAndPid = try symbol(
            "_AXUIElementCreateWithDataAndPid",
            (@convention(c) (CFData, Int32, pid_t, pid_t) -> AXUIElement).self
        ).get()
        XCTAssertNotNil(CreateWithDataAndPid)
        let axUIElement1 = CreateWithDataAndPid(
            "boop".data(using: .utf8)! as CFData,
            1,
            2,
            0
        )
        XCTAssertNotNil(axUIElement1)
        XCTAssertEqual(try (axUIElement1 as UIElement).pid, 2)
        let axUIElement2 = CreateWithDataAndPid(
            "boop".data(using: .utf8)! as CFData,
            1,
            2,
            0
        )
        XCTAssertNotNil(axUIElement2)
        XCTAssertEqual(try (axUIElement2 as UIElement).pid, 2)
        XCTAssertTrue(CFEqual(axUIElement1, axUIElement2))
        XCTAssertEqual(axUIElement1 as UIElement, axUIElement2 as UIElement)
    }
    func testCastingFails() throws {
        let test: Any = NSArray()
        XCTAssertNil(test as? UIElement)
    }
}
