//
//  AX.swift
//
//  Copyright © 2017-2023 Doug Russell. All rights reserved.
//

import ApplicationServices.HIServices
import Foundation

/// Returns `true` if current process is a trusted accessibility client.
///
/// See also `public func AXIsProcessTrusted() -> Bool`
///
/// - Returns: `true` if current process is a trusted accessibility client.
@available(macOS 10.4, *)
@Sendable
public func isTrusted() -> Bool {
    AXIsProcessTrusted()
}
/// Returns `true` if current process is a trusted accessibility client.
///
/// Prompting occurs asynchronously and does not affect the return value.
///
/// See also `public func AXIsProcessTrustedWithOptions(_ options: CFDictionary?) -> Bool`
///
/// - Parameters:
///     - promptIfNeeded: Indicates whether the user will be informed if the current process is untrusted.
///     This could be used, for example, on application startup to always warn a user if accessibility
///     is not enabled for the current process.
/// - Returns: `true` if current process is a trusted accessibility client.
@available(macOS 10.9, *)
@Sendable
public func isTrusted(promptIfNeeded: Bool) -> Bool {
    AXIsProcessTrustedWithOptions(optionsDictionary(promptIfNeeded: promptIfNeeded))
}
private struct AXKey: Sendable {
    static let trustedCheckOptionPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
}
private func optionsDictionary(promptIfNeeded: Bool) -> CFDictionary {
    guard promptIfNeeded else {
        return [CFString:CFTypeRef]() as CFDictionary
    }
    return [AXKey.trustedCheckOptionPrompt:kCFBooleanTrue] as CFDictionary
}
