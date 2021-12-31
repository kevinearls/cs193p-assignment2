//
//  Assignment2App.swift
//  Assignment2
//
//  Created by Kevin Earls on 21/12/2021.
//

import SwiftUI

@main
struct Assignment2App: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
