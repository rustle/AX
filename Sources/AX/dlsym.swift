//
//  dlsym.swift
//
//  Copyright © 2017-2026 Doug Russell. All rights reserved.
//

import Darwin

enum SymbolError: Error {
    case missingSymbol(String)
}

func symbol<F>(
    _ name: String,
    _ type: F.Type
) throws -> F {
    let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)!
    guard let symbol = dlsym(RTLD_DEFAULT, name) else {
        throw SymbolError.missingSymbol(name)
    }
    return unsafeBitCast(
        symbol,
        to: type.self
    )
}
