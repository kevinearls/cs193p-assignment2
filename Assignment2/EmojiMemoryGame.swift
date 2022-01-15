//
//  EmojiMemoryGame.swift
//  Assignment2
//
//  Created by Kevin Earls on 21/12/2021.
//
// NOTE: This is the viewModel

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame<String>() 
    }
    
    @Published private (set) var model = createMemoryGame()
    
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    // FIXME: 
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


