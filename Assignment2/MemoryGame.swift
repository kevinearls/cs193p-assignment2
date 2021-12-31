//
//  MemoryGame.swift
//  Assignment2
//
//  Created by Kevin Earls on 21/12/2021.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    private var score = 0
    
    let vehicleEmojis =  ["✈️",  "🚃", "🚅", "🚁", "🚕", "🚗", "🚙", "🚌", "🚎", "🏎", "🚢", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🦽", "🦼", "🛴", "🚲", "🛵", "🏍"]
    let fruitEmojis = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑"]
    let animalEmojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🙈", "🙉", "🙊", "🐒", "🐔", "🐧", "🐦"]
    let sportsEmojis = [ "🏈", "⚽️", "🏀", "🏋🏻" ]
    var chosenTheme: Theme?
    var themes: [String: Theme] = [:]
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            // Two cards are chosen
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {
                    if cards[potentialMatchIndex].hasBeenSeen {
                        score -= 1
                    }
                    if cards[chosenIndex].hasBeenSeen {
                        score -= 1
                    }
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                // Only one card here...
                print("only one")
                for index in cards.indices {
                    if cards[index].isFaceUp && !cards[index].isMatched {
                        cards[index].hasBeenSeen = true
                    }
                    cards[index].isFaceUp = false  
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    func getCurrentTheme() -> String {
        return chosenTheme!.name
    }
    
    func getCardColor() -> Color {
        return chosenTheme!.color
    }
    
    func getScore() -> Int {
        return score
    }
    
    init() {
        cards = Array<Card>()
        
        let animals = Theme(name: "animals", color:Color.red, numberOfPairsOfCards: 4, emoji: animalEmojis)
        let fruits = Theme(name: "fruits", color:Color.blue, numberOfPairsOfCards: 6, emoji: fruitEmojis)
        let vehicles = Theme(name: "vehicles", color:Color.green, numberOfPairsOfCards: 8, emoji: vehicleEmojis)
        let sports = Theme(name: "sports", color:Color.brown, numberOfPairsOfCards: 3, emoji: sportsEmojis)
        themes[animals.name] = animals
        themes[fruits.name] = fruits
        themes[vehicles.name] = vehicles
        themes[sports.name] = sports
        
        // Pick a theme for this game at random
        let themeIndex = Int.random(in: 0..<themes.count)
        let themeNames = Array(themes.keys)
        chosenTheme = themes[themeNames[themeIndex]]
        
        let emojis=chosenTheme!.emoji.shuffled()
        let cardLimit = min(chosenTheme!.numberOfPairsOfCards, chosenTheme!.emoji.count)
        for pairIndex in 0..<cardLimit {
            let content = emojis[pairIndex]
            cards.append(Card(content: content as! CardContent, id: pairIndex * 2))
            cards.append(Card(content: content as! CardContent, id: pairIndex * 2 + 1))
        }
        
        cards = cards.shuffled()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var hasBeenSeen = false
        var content: CardContent
        var id: Int
    }
    
    struct Theme {
        var name: String
        var color: Color
        var numberOfPairsOfCards: Int
        var emoji: [String]
    }
}
