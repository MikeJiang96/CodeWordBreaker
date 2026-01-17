//
//  CodeWordBreakerApp.swift
//  CodeWordBreaker
//
//  Created by Mike Jiang on 2026/1/12.
//

import SwiftData
import SwiftUI

@main
struct CodeWordBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: CodeWordBreaker.self)
        }
    }
}
