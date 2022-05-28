//
//  AXValueTests.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import XCTest
@testable import AX

@available(macOS 12, *)
final class AXTextMarkerTests: XCTestCase {
    func testTextMarkerRoundTrip() {
        var uuid = UUID().uuidString
        let length = uuid.lengthOfBytes(using: .utf8)
        let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: length)
        _ = uuid.withUTF8 { buf in
            buffer.initialize(from: buf)
        }
        let axTextMarker = AXTextMarkerCreate(
            kCFAllocatorDefault,
            buffer.baseAddress!,
            length
        )
        let textMarker = axTextMarker as TextMarker
        let backToAxTextMarker = textMarker as AXTextMarker
        let backToBytes = UnsafeBufferPointer(
            start: AXTextMarkerGetBytePtr(backToAxTextMarker),
            count: AXTextMarkerGetLength(backToAxTextMarker)
        )
        let backToUUID = String(cString: backToBytes.baseAddress!)
        XCTAssertEqual(
            uuid,
            backToUUID
        )
        buffer.deallocate()
    }
    func testAXTextMarkerToTextMarker() {
        var uuid = UUID().uuidString
        let length = uuid.lengthOfBytes(using: .utf8)
        let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: length)
        _ = uuid.withUTF8 { buf in
            buffer.initialize(from: buf)
        }
        let axTextMarker = AXTextMarkerCreate(
            kCFAllocatorDefault,
            buffer.baseAddress!,
            length
        )
        let textMarker = axTextMarker as TextMarker
        textMarker.withUnsafeBytes { buf in
            let backToUUID = String(cString: buf.baseAddress!.assumingMemoryBound(to: UInt8.self))
            XCTAssertEqual(
                uuid,
                backToUUID
            )
        }
        buffer.deallocate()
    }
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

        let textMarkerStart = axTextMarkerStart as TextMarker
        let textMarkerEnd = axTextMarkerEnd as TextMarker

        let range = TextMarkerRange(
            lowerBound: textMarkerStart,
            upperBound: textMarkerEnd
        )

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
