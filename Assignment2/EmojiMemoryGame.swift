//
//  EmojiMemoryGame.swift
//  Assignment2
//
//  Created by Kevin Earls on 21/12/2021.
//

import SwiftUI

class EmojiMemoryGame {
    static let emojis = ["✈️",  "🚃", "🚅", "🚁", "🚕", "🚗", "🚙", "🚌", "🚎", "🏎", "🚢", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🦽", "🦼", "🛴", "🚲", "🛵", "🏍"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            EmojiMemoryGame.emojis[pairIndex]
        }
    }
    
    private (set) var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
}


