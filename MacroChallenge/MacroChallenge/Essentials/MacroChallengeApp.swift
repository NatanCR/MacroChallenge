//
//  MacroChallengeApp.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 30/05/23.
//

import SwiftUI

@main
struct MacroChallengeApp: App {
    @ObservedObject var appState = AppState()
    var body: some Scene {
        WindowGroup {
            GeometryReader { geo in
                HomeView()
                    .environmentObject(appState)
                    .environment(\.screenSize, geo.size)
            }
        }
    }
}

private struct ScreenSizeKey : EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
}
