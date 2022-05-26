//
//  SimpleObserver.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import AX
import Cocoa

fileprivate func observer_callback(_ observer: AXObserver,
                                   _ uiElement: AXUIElement,
                                   _ name: CFString,
                                   _ info: CFDictionary?,
                                   _ refCon: UnsafeMutableRawPointer?) {
    print(observer)
    print(observer as Observer)
    print(uiElement)
    print(uiElement as UIElement)
}

fileprivate func run() -> Never {
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

func runSimpleObserver() -> Never {
    do {
        guard let finder = NSWorkspace.shared.runningApplications.filter({ app in
            app.bundleIdentifier == "com.apple.finder"
        }).first else {
            print(NSWorkspace.shared.runningApplications.compactMap(\.bundleIdentifier))
            exit(1)
        }
        let element = UIElement.application(pid: finder.processIdentifier)
        print(element)
        print(element as AXUIElement)
        let observer = try Observer(pid: element.pid,
                                    callback: observer_callback)
        print(observer)
        print(observer as AXObserver)
        observer.schedule(on: .main)
        try observer.add(element: element,
                         notification: .focusedUIElementChanged,
                         context: nil)
        run()
    } catch {
        print(error)
        exit(1)
    }
}
