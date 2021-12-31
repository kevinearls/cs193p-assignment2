//
//  EmojiMemoryGameView.swift
//  Assignment2
//
//  Created by Kevin Earls on 21/12/2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text(game.getTheme()).font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
                    ForEach(game.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                game.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(game.getColor())
            .font(.largeTitle)
            .padding(.horizontal)
            Text("Score: \(game.getScore())").font(.largeTitle)
            Button("New Game", action: game.startNewGame ).buttonStyle(.bordered)
        }
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        let shape=RoundedRectangle(cornerRadius: 20.0)
        ZStack {
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3.0)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0.1)
            } else {
                shape.fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game).preferredColorScheme(.light)
        //ContentView().preferredColorScheme(.dark)
    }
   
}

