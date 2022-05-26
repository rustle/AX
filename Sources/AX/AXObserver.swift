//
//  AXObserver.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import ApplicationServices.HIServices
import Foundation
import AppKit

@available(macOS 10.2, *)
public struct Observer: CustomDebugStringConvertible {

    // MARK: Init

    public let observer: AXObserver
    public init(observer: AXObserver) {
        self.observer = observer
    }

    /// Create a new accessibility notification observer for pid with callback
    ///
    /// See also `public func AXObserverCreateWithInfoCallback(_ application: pid_t, _ callback: @escaping ApplicationServices.AXObserverCallbackWithInfo, _ outObserver: UnsafeMutablePointer<AXObserver?>) -> AXError`
    public init(
        pid: pid_t,
        callback: @escaping AXObserverCallbackWithInfo
    ) throws {
        var observer: AXObserver?
        self.observer = try AXObserverCreateWithInfoCallback(pid,
                                                            callback,
                                                            &observer)
        .check(observer)
}

    // MARK: Utility

    public var debugDescription: String {
        "<Observer \(String(describing: observer))>"
    }

    public var description: String {
        debugDescription
    }

    // MARK: Scheduling

    /// Receiver must be scheduled on a run loop before it can receive notifications.
    ///
    /// See also `public func AXObserverGetRunLoopSource(_ observer: AXObserver) -> CFRunLoopSource`
    public var runLoopSource: CFRunLoopSource {
        AXObserverGetRunLoopSource(observer)
    }
    /// Convenience method to add `runLoopSource` to the current `RunLoop`
    public func schedule() {
        CFRunLoopAddSource(
            CFRunLoopGetCurrent(),
            runLoopSource,
            CFRunLoopMode.defaultMode
        )
    }
    /// Convenience method to add `runLoopSource` to a given `RunLoop`
    public func schedule(on runLoop: RunLoop) {
        CFRunLoopAddSource(
            runLoop.getCFRunLoop(),
            runLoopSource,
            CFRunLoopMode.defaultMode
        )
    }
    /// Convenience method to remove `runLoopSource` from a given `RunLoop`
    public func unschedule(on runLoop: RunLoop) {
        CFRunLoopRemoveSource(
            runLoop.getCFRunLoop(),
            runLoopSource,
            CFRunLoopMode.defaultMode
        )
    }
    /// Convenience method to remove `runLoopSource` from the current `RunLoop`
    public func unschedule() {
        CFRunLoopRemoveSource(
            CFRunLoopGetCurrent(),
            runLoopSource,
            CFRunLoopMode.defaultMode
        )
    }
    /// Registers observer to receive notifications from the specified element.
    ///
    /// See also `public func AXObserverAddNotification(_ observer: AXObserver, _ element: AXUIElement, _ notification: CFString, _ refcon: UnsafeMutableRawPointer?) -> AXError`
    public func add(
        element: UIElement,
        notification: NSAccessibility.Notification,
        context: UnsafeMutableRawPointer?
    ) throws {
        try AXObserverAddNotification(
            observer,
            element.element,
            notification as CFString,
            context
        )
            .check()
    }
    /// Removes the specified notification from the list of notifications observer may receive from the specified element.
    ///
    /// See also `public func AXObserverRemoveNotification(_ observer: AXObserver, _ element: AXUIElement, _ notification: CFString) -> AXError`
    public func remove(
        element: UIElement,
        notification: NSAccessibility.Notification
    ) throws {
        try AXObserverRemoveNotification(
            observer,
            element.element,
            notification as CFString
        )
            .check()
    }
}

extension Observer: ReferenceConvertible {
    public typealias ReferenceType = NSObject & NSCopying
    public typealias _ObjectiveCType = AXObserver
    public func _bridgeToObjectiveC() -> _ObjectiveCType {
        observer
    }
    public static func _forceBridgeFromObjectiveC(
        _ source: _ObjectiveCType,
        result: inout Observer?
    ) {
        result = .init(observer: source)
    }
    public static func _conditionallyBridgeFromObjectiveC(
        _ source: _ObjectiveCType,
        result: inout Observer?
    ) -> Bool {
        guard CFGetTypeID(source) == AXObserverGetTypeID() else { return false }
        result = .init(observer: source)
        return true
    }
    public static func _unconditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType?) -> Observer {
        .init(observer: source!)
    }
}
