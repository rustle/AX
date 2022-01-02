//
//  AXObserver.swift
//
//  Copyright © 2017-2021 Doug Russell. All rights reserved.
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
    public init(pid: pid_t,
                callback: @escaping AXObserverCallbackWithInfo) throws {
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
    /// Receiver must be scheduled on a run loop before it can receive notifications.
    ///
    /// See also `public func AXObserverGetRunLoopSource(_ observer: AXObserver) -> CFRunLoopSource`
    public func schedule(on runLoop: RunLoop) {
        CFRunLoopAddSource(runLoop.getCFRunLoop(),
                           runLoopSource,
                           CFRunLoopMode.defaultMode)
    }
    /// Registers observer to receive notifications from the specified element.
    ///
    /// See also `public func AXObserverAddNotification(_ observer: AXObserver, _ element: AXUIElement, _ notification: CFString, _ refcon: UnsafeMutableRawPointer?) -> AXError`
    public func add(element: UIElement,
                    notification: NSAccessibility.Notification,
                    context: UnsafeMutableRawPointer?) throws {
        try AXObserverAddNotification(observer,
                                      element.element,
                                      notification as CFString,
                                      context)
            .check()
    }
    /// Removes the specified notification from the list of notifications observer may receive from the specified element.
    ///
    /// See also `public func AXObserverRemoveNotification(_ observer: AXObserver, _ element: AXUIElement, _ notification: CFString) -> AXError`
    public func remove(element: UIElement,
                       notification: NSAccessibility.Notification,
                       context: UnsafeMutableRawPointer?) throws {
        try AXObserverRemoveNotification(observer,
                                         element.element,
                                         notification as CFString)
            .check()
    }
}
