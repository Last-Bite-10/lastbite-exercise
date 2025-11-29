//
//  Debugging.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

struct Debugging {
    public static func debug(_ items: Any) {
        #if DEBUG
            debugPrint("[ExaMove]: \(items)")
        #endif
    }
}
