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
//            ContentView()
            ListView()
                .environmentObject(appState)
        }
    }
}
