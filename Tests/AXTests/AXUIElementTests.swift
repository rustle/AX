//
//  AXUIElementTests.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import XCTest
@testable import AX

@available(macOS 10.0, *)
final class AXUIElementTests: XCTestCase {
    func testUIElementCast() throws {
        let axUIElement = AXUIElementCreateApplication(10)
        XCTAssertEqual(try (axUIElement as UIElement).pid, 10)
    }
}
