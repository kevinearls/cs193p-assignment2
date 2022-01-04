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
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                if card.isMatched  && !card.isFaceUp {
                    Rectangle().opacity(0.1)
                } else {
                    CardView(card: card)
                        .padding(4)
                        .onTapGesture { game.choose(card) }
                }
            }
            .foregroundColor(game.getColor())
            .padding(.horizontal)
            Text("Score: \(game.getScore())").font(.largeTitle)
            Button("New Game", action: game.startNewGame ).buttonStyle(.bordered)
        }
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    fileprivate func font(in size: CGSize) -> Font {
        return Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    var body: some View {
        let shape=RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0.1)
                } else {
                    shape.fill()
                }
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

private struct DrawingConstants {
    static let cornerRadius:CGFloat = 10.0
    static let lineWidth:CGFloat = 3.0
    static let fontScale:CGFloat = 0.75
}



