//
//  ObserverExample.swift
//
//  Copyright © 2017-2021 Doug Russell. All rights reserved.
//

import AX
import Cocoa

guard isTrusted(promptIfNeeded: true) else {
    // If you already added ObserverExample
    // to trusted apps, it's likely that changing the
    // binary has invalidated it's AX API access.
    // You can usually reauthorize it by unchecking and
    // rechecking it's entry in the list of apps
    // with AX API access in System Preferences.
    print("Not Trusted")
    exit(1)
}

runSimpleObserver()
