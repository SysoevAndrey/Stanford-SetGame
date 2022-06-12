//
//  SetApp.swift
//  Set
//
//  Created by Andrey Sysoev on 11.06.2022.
//

import SwiftUI

@main
struct SetApp: App {
    let game = SetGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
