//
//  EmojiMemoryGame.swift
//  Assignment2
//
//  Created by Kevin Earls on 21/12/2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame<String>() 
    }
    
    @Published private (set) var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    
    func getTheme() -> String {
        model.getCurrentTheme()
    }
    
    func getColor() -> Color {
        model.getCardColor()
    }
    
    func getScore() -> Int {
        model.getScore()
    }
    
    
}


