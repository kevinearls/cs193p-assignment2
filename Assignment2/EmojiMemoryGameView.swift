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
            AspectVGrid(items: game.cards, aspectRatio: DrawingConstants.cardAspectRatio) { card in
                if card.isMatched  && !card.isFaceUp {
                    Rectangle().opacity(DrawingConstants.matchedCardOpacity)
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
        GeometryReader { geometry in
            ZStack {
                // NOTE: we're no using normal Cartesian coordinates here...
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90), clockwise: true)
                    .padding(5)
                    .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                // FIXME this card is too big
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
               
            }.cardify(isFaceUp: card.isFaceUp)
        }
    }
}

private func scale(thatFits size:CGSize) -> CGFloat {
    let result = min(size.width, size.height) / DrawingConstants.fontSize / DrawingConstants.fontScale
    //print("Scale should be returning \(result)")  // WTF why is this not working correctly
    //return CGFloat(1.0)
    return result
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        //game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
        //ContentView().preferredColorScheme(.dark)
    }
}

private struct DrawingConstants {
    static let fontScale:CGFloat = 0.70
    static let fontSize:CGFloat = 32
    static let wtfScaleEffect = 1
    static let matchedCardOpacity:CGFloat = 0.05
    static let cardAspectRatio:CGFloat = 2/3
}
