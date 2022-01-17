//
//  MemoryGame.swift
//  Assignment2
//
//  Created by Kevin Earls on 21/12/2021.
//
// This is the model

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp}).oneAndOnly }
        set { cards.indices.forEach({ cards[$0].isFaceUp = ($0 == newValue) })}
    }
    
    private var score = 0
    
    // Class examples: Haloween, Flags, Vehicles, Faces Food, Places
    let vehicleEmojis =  ["✈️",  "🚃", "🚅", "🚁", "🚕", "🚗", "🚙", "🚌", "🚎", "🏎", "🚢", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🦽", "🦼", "🛴", "🚲", "🛵", "🏍"]
    let fruitEmojis = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑"]
    let animalEmojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🙈", "🙉", "🙊", "🐒", "🐔", "🐧", "🐦"]
    let sportsEmojis = [ "🏈", "⚽️", "🏀", "🏋🏻" ]
    private var chosenTheme: Theme?
    private var themes: [String: Theme] = [:]
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        print("Card \(card.id) was chosen")
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            // Two cards are chosen
            print("Chosen index was \(chosenIndex)")
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
                cards[chosenIndex].isFaceUp = true
            } else {
                // Only one card here...
                for index in cards.indices {
                    if cards[index].isFaceUp && !cards[index].isMatched {
                        cards[index].hasBeenSeen = true
                    }
                    //cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            // cards[chosenIndex].isFaceUp.toggle()
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
        cards = []
        
        let animals = Theme(name: "animals", color:Color.red, numberOfPairsOfCards: 8, emoji: animalEmojis)
        let fruits = Theme(name: "fruits", color:Color.blue, numberOfPairsOfCards: 8, emoji: fruitEmojis)
        let vehicles = Theme(name: "vehicles", color:Color.green, numberOfPairsOfCards: 8, emoji: vehicleEmojis)
        let sports = Theme(name: "sports", color:Color.brown, numberOfPairsOfCards: 4, emoji: sportsEmojis)
        themes[animals.name] = animals
        themes[fruits.name] = fruits
        themes[vehicles.name] = vehicles
        themes[sports.name] = sports
        
        // Pick a theme for this game at random
        //let themeIndex = Int.random(in: 0..<themes.count)
        let themeIndex = 2 // FIXME remove this
        let themeNames = Array(themes.keys)
        chosenTheme = themes[themeNames[themeIndex]]
        
        let emojis=chosenTheme!.emoji.shuffled()
        let cardLimit = min(chosenTheme!.numberOfPairsOfCards, chosenTheme!.emoji.count)
        for pairIndex in 0..<cardLimit {
            let content = emojis[pairIndex]
            cards.append(Card(content: content as! CardContent, id: pairIndex * 2))
            cards.append(Card(content: content as! CardContent, id: pairIndex * 2 + 1))
        }
        
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var hasBeenSeen: Bool = false
        let content: CardContent
        let id: Int
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

private struct Theme {
    var name: String
    var color: Color
    var numberOfPairsOfCards: Int
    var emoji: [String]
}

extension Array {
    var oneAndOnly: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}
