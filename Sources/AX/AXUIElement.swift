//
//  AXUIElement.swift
//
//  Copyright © 2017-2021 Doug Russell. All rights reserved.
//

import Cocoa

@available(macOS 10.0, *)
public struct UIElement: CustomStringConvertible, CustomDebugStringConvertible {

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

    // MARK: Utility

    /// Proccess identifier of application associated with receiver
    ///
    /// See also  `public func AXUIElementGetPid(_ element: AXUIElement, _ pid: UnsafeMutablePointer<pid_t>) -> AXError`
    public var pid: pid_t {
        get throws {
            var pid: pid_t = 0
            let result = AXUIElementGetPid(element,
                                           &pid)
            return try result.check(pid)
        }
    }
    public var description: String {
        debugDescription
    }
    public var debugDescription: String {
        var description = [String(describing: element)]
        if let attrs = try? attributes(), attrs.count > 0 {
            description.append("Attributes: \(attrs.map(\.rawValue))")
            func append(_ prefix: String, _ attribute: NSAccessibility.Attribute) {
                guard attrs.contains(attribute), let value = try? value(attribute: attribute) else {
                    return
                }
                description.append(prefix)
                description.append(String(describing: value))
            }
            append("Role:", .role)
            append("Subrole:", .subrole)
            append("Title:", .title)
            append("Description:", .description)
            append("Value:", .value)
        }
        return "<UIElement \(description.joined(separator: " "))>"
    }

    // MARK: Attributes

    ///
    ///
    /// See also `public func AXUIElementCopyAttributeNames(_ element: AXUIElement, _ names: UnsafeMutablePointer<CFArray?>) -> AXError`
    public func attributes() throws -> [NSAccessibility.Attribute] {
        var attributes: CFArray?
        let result = AXUIElementCopyAttributeNames(element,
                                                   &attributes)
        return try result.check(attributes)
    }
    ///
    ///
    /// See also `public func AXUIElementCopyAttributeValue(_ element: AXUIElement, _ attribute: CFString, _ value: UnsafeMutablePointer<CFTypeRef?>) -> AXError`
    public func value(attribute: NSAccessibility.Attribute) throws -> Any {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element,
                                                   attribute as CFString,
                                                   &value)
        return try result.check(value)
    }
    public func value<V>(attribute: NSAccessibility.Attribute) throws -> V {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element,
                                                   attribute as CFString,
                                                   &value)
        return try result.check(value)
    }
    /// Returns the count of the array type attribute value.
    ///
    /// See also `public func AXUIElementGetAttributeValueCount(_ element: AXUIElement, _ attribute: CFString, _ count: UnsafeMutablePointer<CFIndex>) -> AXError`
    public func count(attribute: NSAccessibility.Attribute) throws -> Int {
        var count: CFIndex = kCFNotFound
        return try AXUIElementGetAttributeValueCount(element,
                                                     attribute as CFString,
                                                     &count)
            .check(count)
    }
    /// Returns an array of attribute values for the attribute, starting at the specified index.
    /// 
    /// This function is useful for dealing with large arrays, for example, a table view with a large number of children.
    ///
    /// See also `public func AXUIElementCopyAttributeValues(_ element: AXUIElement, _ attribute: CFString, _ index: CFIndex, _ maxValues: CFIndex, _ values: UnsafeMutablePointer<CFArray?>) -> AXError`
    public func values(attribute: NSAccessibility.Attribute,
                       index: Int,
                       maxCount: Int) throws -> [Any] {
        var values: CFArray?
        return try AXUIElementCopyAttributeValues(element, attribute as CFString, index, maxCount, &values)
            .check(values)
    }
    public func values<V>(attribute: NSAccessibility.Attribute,
                          index: Int,
                          maxCount: Int) throws -> [V] {
        var values: CFArray?
        return try AXUIElementCopyAttributeValues(element, attribute as CFString, index, maxCount, &values)
            .check(values)
    }

    // MARK: Parameterized Attributes

    ///
    ///
    /// See also `public func AXUIElementCopyParameterizedAttributeNames(_ element: AXUIElement, _ names: UnsafeMutablePointer<CFArray?>) -> AXError`
    public func parameterizedAttributes() throws -> [NSAccessibility.Attribute] {
        var attributes: CFArray?
        let result = AXUIElementCopyParameterizedAttributeNames(element,
                                                                &attributes)
        return try result.check(attributes)
    }
    ///
    ///
    /// See also `public func AXUIElementCopyParameterizedAttributeValue(_ element: AXUIElement, _ parameterizedAttribute: CFString, _ parameter: CoreFoundation.CFTypeRef, _ result: UnsafeMutablePointer<CoreFoundation.CFTypeRef?>) -> AXError`
    public func value(attribute: NSAccessibility.ParameterizedAttribute,
                      parameter: Any) throws -> Any {
        var value: CFTypeRef?
        let result = AXUIElementCopyParameterizedAttributeValue(element,
                                                                attribute.rawValue as CFString,
                                                                parameter as CFTypeRef,
                                                                &value)
        return try result.check(value)
    }
    public func value<V>(attribute: NSAccessibility.ParameterizedAttribute,
                         parameter: Any) throws -> V {
        var value: CFTypeRef?
        let result = AXUIElementCopyParameterizedAttributeValue(element,
                                                                attribute.rawValue as CFString,
                                                                parameter as CFTypeRef,
                                                                &value)
        return try result.check(value)
    }

    // MARK: Set/isSettable

    ///
    ///
    /// See also `public func AXUIElementIsAttributeSettable(_ element: AXUIElement, _ attribute: CFString, _ settable: UnsafeMutablePointer<DarwinBoolean>) -> AXError`
    func isSettable(attribute: NSAccessibility.Attribute) throws -> Bool {
        var value: DarwinBoolean = false
        let result = AXUIElementIsAttributeSettable(element,
                                                    attribute.rawValue as CFString,
                                                    &value)
        return try result.check(value.boolValue)
    }
    ///
    ///
    /// See also `public func AXUIElementSetAttributeValue(_ element: AXUIElement, _ attribute: CFString, _ value: CoreFoundation.CFTypeRef) -> AXError`
    func set(attribute: NSAccessibility.Attribute,
             value: Any?) throws {
        try AXUIElementSetAttributeValue(element,
                                         attribute.rawValue as CFString,
                                         value as CFTypeRef)
            .check()
    }

    // MARK: Actions

    ///
    ///
    /// See also `public func AXUIElementCopyActionNames(_ element: AXUIElement, _ names: UnsafeMutablePointer<CFArray?>) -> AXError`
    func actions() throws -> [NSAccessibility.Action] {
        var actions: CFArray?
        return try AXUIElementCopyActionNames(element,
                                              &actions)
            .check(actions)
    }
    ///
    ///
    /// See also `public func AXUIElementCopyActionDescription(_ element: AXUIElement, _ action: CFString, _ description: UnsafeMutablePointer<CFString?>) -> AXError`
    func description(action: NSAccessibility.Action) throws -> String {
        var description: CFString?
        return try AXUIElementCopyActionDescription(element,
                                                    action.rawValue as CFString,
                                                    &description)
            .check(description)
    }
    ///
    ///
    /// See also `public func AXUIElementPerformAction(_ element: AXUIElement, _ action: CFString) -> AXError`
    func perform(action: NSAccessibility.Action) throws {
        try AXUIElementPerformAction(element,
                                     action as CFString)
            .check()
    }
}

extension UIElement: ReferenceConvertible {
    public typealias ReferenceType = NSObject & NSCopying
    public typealias _ObjectiveCType = AXUIElement
    public func _bridgeToObjectiveC() -> _ObjectiveCType {
        element
    }
    public static func _forceBridgeFromObjectiveC(_ source: _ObjectiveCType,
                                                  result: inout UIElement?) {
        result = .init(element: source)
    }
    public static func _conditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType,
                                                          result: inout UIElement?) -> Bool {
        guard CFGetTypeID(source) == AXUIElementGetTypeID() else { return false }
        result = .init(element: source)
        return true
    }
    public static func _unconditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType?) -> UIElement {
        .init(element: source!)
    }
}
