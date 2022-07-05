//
//  AXTextMarkerTests.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import XCTest
@testable import AX

@available(macOS 11, *)
final class AXTextMarkerRangeTests: XCTestCase {
    func testTextMarkerRangeRoundTrip() {
        var uuidStart = UUID().uuidString
        var uuidEnd = UUID().uuidString

        let lengthStart = uuidStart.lengthOfBytes(using: .utf8)
        let lengthEnd = uuidEnd.lengthOfBytes(using: .utf8)

        let bufferStart = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: lengthStart)
        _ = uuidStart.withUTF8 { buf in
            bufferStart.initialize(from: buf)
        }
        let bufferEnd = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: lengthEnd)
        _ = uuidEnd.withUTF8 { buf in
            bufferEnd.initialize(from: buf)
        }

        let axTextMarkerStart = AXTextMarkerCreate(
            kCFAllocatorDefault,
            bufferStart.baseAddress!,
            lengthStart
        )
        let axTextMarkerEnd = AXTextMarkerCreate(
            kCFAllocatorDefault,
            bufferEnd.baseAddress!,
            lengthEnd
        )
        let axTextMarkerRange = AXTextMarkerRangeCreate(
            kCFAllocatorDefault,
            axTextMarkerStart,
            axTextMarkerEnd
        )

        let range = axTextMarkerRange as TextMarkerRange

        let backToAxTextMarkerStart = range.lowerBound as AXTextMarker
        let backToAxTextMarkerEnd = range.upperBound as AXTextMarker

        let backToBytesStart = UnsafeBufferPointer(
            start: AXTextMarkerGetBytePtr(backToAxTextMarkerStart),
            count: AXTextMarkerGetLength(backToAxTextMarkerStart)
        )
        let backToBytesEnd = UnsafeBufferPointer(
            start: AXTextMarkerGetBytePtr(backToAxTextMarkerEnd),
            count: AXTextMarkerGetLength(backToAxTextMarkerEnd)
        )

        let backToUUIDStart = String(cString: backToBytesStart.baseAddress!)
        let backToUUIDEnd = String(cString: backToBytesEnd.baseAddress!)

        XCTAssertEqual(
            uuidStart,
            backToUUIDStart
        )
        XCTAssertEqual(
            uuidEnd,
            backToUUIDEnd
        )

        bufferStart.deallocate()
        bufferEnd.deallocate()
    }
}
