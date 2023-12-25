# AX

Hopefully make it a little easier to use HIServices Accessibility APIs in Swift.

The goal of this package is to provide a nice overlay to existing API, not extend any functionality or solve any of the thorny parts of using the HIServices Accessibility APIs.

### Observer Example

Simplified example to show how to setup an `AX` `Observer` for `NSAccessibility.Notification`s from an application element.

You'll need to add/re-add `ObserverExample` to trusted apps for Accessibility in System Preferences any time you change the code.

### Integration

Lots of good examples for integrating and using `AX` are available in [AccessibilityElement](https://github.com/rustle/AccessibilityElement).

### Use of _ API

AX makes liberal use of `ReferenceConvertible`. More specifically `_` prefixed (aka unstable)  `_ObjectiveCType`, `_forceBridgeFromObjectiveC`, `_conditionallyBridgeFromObjectiveC`, and `_unconditionallyBridgeFromObjectiveC`. These give us the extremely nice to have ability to bridge not only individual elements

```swift
func foo(
    _ uiElement: AXUIElement,
) {
	let element = uiElement as UIElement
	…
}
```

but collections

```swift
func foo(
    _ uiElements: CFArrayRef?,
) {
	guard let elements = uiElements as [UIElement] else { return }
	…
}
```

Hopefully eventually a stable variant is provided and we can migrate to that. If push comes to shove this logic can be excised by adding helper functions that do functionally equivalent bridging.

## License

AX is released under an Apache license. See the LICENSE file for more information.
