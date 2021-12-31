//
//  AXUIElement.swift
//
//  Copyright © 2017-2021 Doug Russell. All rights reserved.
//

import ApplicationServices.HIServices

@available(macOS 10.0, *)
public extension 🪓 {
    struct UIElement {

        // MARK: Init

        public let element: AXUIElement
        public init(element: AXUIElement) {
            self.element = element
        }
        /// Accessibility element that provides access to system attributes.
        ///
        /// Useful for finding the focused accessibility element regardless of which application
        /// is currently active.
        ///
        /// See also `public func AXUIElementCreateSystemWide() -> AXUIElement`
        public static func systemWide() -> UIElement {
            UIElement(element: AXUIElementCreateSystemWide())
        }
        /// Accessibility element that provides access to a given application by pid.
        ///
        /// See also `func AXUIElementCreateApplication(_ pid: pid_t) -> AXUIElement`
        public static func application(pid: pid_t) -> UIElement {
            UIElement(element: AXUIElementCreateApplication(pid))
        }
        /// Accessibility element based on hit testing.
        ///
        /// Elements are found via hit-testing based on window z-order (that is, layering). If one window is on top of another window, the returned
        /// accessibility object comes from whichever window is topmost at the specified location.
        /// Note that if the receiver is the `systemWide()` element, the position test is not restricted to a particular application.
        ///
        /// See also `func AXUIElementCopyElementAtPosition(_ application: AXUIElement, _ x: Float, _ y: Float, _ element: UnsafeMutablePointer<AXUIElement?>) -> AXError`
        public func element(at point: CGPoint) throws -> UIElement {
            var element: AXUIElement?
            let result = AXUIElementCopyElementAtPosition(self.element,
                                                          Float(point.x),
                                                          Float(point.y),
                                                          &element)
            return UIElement(element: try result.check(element))
        }
    }
}
