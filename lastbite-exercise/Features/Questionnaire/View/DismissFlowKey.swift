//
//  DismissFlowKey.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 09/11/25.
//

import SwiftUI

/// Kunci Environment kustom untuk menyimpan closure "dismiss flow".
/// Ini memungkinkan view mana pun di dalam tumpukan navigasi untuk
/// menutup seluruh sheet/cover modal.
struct DismissFlowKey: EnvironmentKey {
    static var defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var dismissFlow: () -> Void {
        get { self[DismissFlowKey.self] }
        set { self[DismissFlowKey.self] = newValue }
    }
}
