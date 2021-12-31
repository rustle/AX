//
//  ObserverExample.swift
//
//  Copyright © 2017-2021 Doug Russell. All rights reserved.
//

import AX
import Cocoa

guard 🪓.isTrusted(promptIfNeeded: true) else {
    print("Not Trusted")
    exit(1)
}

func observer_callback(_ observer: AXObserver,
                               _ uiElement: AXUIElement,
                               _ name: CFString,
                               _ info: CFDictionary?,
                               _ refCon: UnsafeMutableRawPointer?) {
    print("\(observer) \(name)")
}

func main() {
    autoreleasepool {
        Timer.scheduledTimer(withTimeInterval: Date.distantFuture.timeIntervalSince1970,
                             repeats: true) { _ in }
        while true {
            autoreleasepool {
                _ = CFRunLoopRunInMode(CFRunLoopMode.defaultMode,
                                       10.0,
                                       true)
            }
        }
    }
}

do {
    guard let finder = NSWorkspace.shared.runningApplications.filter({ app in
        app.bundleIdentifier == "com.apple.finder"
    }).first else {
        print(NSWorkspace.shared.runningApplications.compactMap(\.bundleIdentifier))
        exit(1)
    }
    let element = 🪓.UIElement.application(pid: finder.processIdentifier)
    let observer = try 🪓.Observer(pid: element.pid,
                                   callback: observer_callback)
    observer.schedule(on: .main)
    try observer.add(element: element,
                     notification: .focusedUIElementChanged,
                     context: nil)
    main()
} catch {
    print(error)
    exit(1)
}
