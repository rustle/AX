//
//  AXObserverTests.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import XCTest
@testable import AX

fileprivate func observer_callback(
    _ observer: AXObserver,
    _ uiElement: AXUIElement,
    _ name: CFString,
    _ info: CFDictionary?,
    _ refCon: UnsafeMutableRawPointer?
) {}

@available(macOS 11, *)
final class AXObserverTests: XCTestCase {
    func testObserverCast() {
        var axObserver: AXObserver?
        let result = AXObserverCreateWithInfoCallback(
            10,
            observer_callback,
            &axObserver
        )
        XCTAssertEqual(result, .success)
        XCTAssertNotNil(axObserver as? Observer)
    }
}
