//
//  PrivateAPILookup.swift
//
//  Copyright © 2017-2026 Doug Russell. All rights reserved.
//

import ApplicationServices
import Foundation

struct TransportRepresentationLookup: Sendable {
    typealias UIElementTransportRepresentation = @convention(c) (AXUIElement) -> Unmanaged<CFData>?
    let transportRepresentation: UIElementTransportRepresentation
    init() throws {
        transportRepresentation = try symbol(
            "_AXUIElementRemoteTokenCreate",
            UIElementTransportRepresentation.self
        )
    }
    func callAsFunction(element: AXUIElement) throws -> Data {
        guard let transportRep = transportRepresentation(element) else {
            throw AXError.noValue
        }
        return transportRep.takeUnretainedValue() as Data
    }
}

struct CreateTransportRepresentationLookup: Sendable {
    typealias UIElementCreateWithTransportRepresentation = @convention(c) (CFData) -> Unmanaged<AXUIElement>?
    let createWithTransportRepresentation: UIElementCreateWithTransportRepresentation
    init() throws {
        createWithTransportRepresentation = try symbol(
            "_AXUIElementCreateWithRemoteToken",
            UIElementCreateWithTransportRepresentation.self
        )
    }
    func callAsFunction(data: Data) throws -> AXUIElement {
        guard let element = createWithTransportRepresentation(data as CFData) else {
            throw AXError.noValue
        }
        return element.takeRetainedValue()
    }
}
