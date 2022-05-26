//
//  AX.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import ApplicationServices.HIServices
import Foundation

/// Returns true if current process is a trusted accessibility client.
///
/// See also `public func AXIsProcessTrusted() -> Bool`
@available(macOS 10.4, *)
public func isTrusted() -> Bool {
    AXIsProcessTrusted()
}
/// Returns true if current process is a trusted accessibility client.
///
/// promptIfNeeded indicates whether the user will be informed if the current process is untrusted.
/// This could be used, for example, on application startup to always warn a user if accessibility
/// is not enabled for the current process.
///
/// Prompting occurs asynchronously and does not affect the return value.
///
/// See also `public func AXIsProcessTrustedWithOptions(_ options: CFDictionary?) -> Bool`
@available(macOS 10.9, *)
public func isTrusted(promptIfNeeded: Bool) -> Bool {
    AXIsProcessTrustedWithOptions(optionsDictionary(promptIfNeeded: promptIfNeeded))
}
private func optionsDictionary(promptIfNeeded: Bool) -> CFDictionary {
    guard promptIfNeeded else {
        return [:] as CFDictionary
    }
    return [kAXTrustedCheckOptionPrompt.takeUnretainedValue():kCFBooleanTrue] as CFDictionary
}
