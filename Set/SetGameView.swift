//
//  SetGameView.swift
//  Set
//
//  Created by Andrey Sysoev on 11.06.2022.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    var body: some View {
        VStack {
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(card: card)
                    .padding(3)
                    .onTapGesture {
                        game.choose(card: card)
                    }
            }
            .padding(.horizontal)
            HStack {
                Button(
                    action: { game.addThreeCards() },
                    label: { Text("Add 3 cards")}
                )
                Spacer()
                Button(
                    action: { game.startNewGame() },
                    label: { Text("New game")}
                )
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}

struct CardView: View {
    let card: SetGameViewModel.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let cardItem = RoundedRectangle(cornerRadius: 10)
                
                cardItem
                    .strokeBorder(lineWidth: card.isSelected ? ViewConstants.selectedStroke : ViewConstants.defaultStroke)
                    .foregroundColor(getBorderColor())
                
                VStack(spacing: geometry.size.height / 10) {
                    ForEach(0..<card.content.numberOfShapes, id: \.self) { _ in
                        switch card.content.shape {
                        case .diamond:
                            let diamond = Diamond(width: geometry.size.width * ViewConstants.scale)
                            
                            ZStack {
                                diamond.stroke()
                                diamond.fill().foregroundColor(getShapeColor(by: card.content))
                            }
                            .frame(
                                width: geometry.size.width * ViewConstants.scale,
                                height: geometry.size.width * ViewConstants.scale / 2.5,
                                alignment: .center
                            )
                            .foregroundColor(card.content.color)
                        case .squiggle:
                            let rectangle = Rectangle()
                            
                            ZStack {
                                rectangle.stroke()
                                rectangle.fill().foregroundColor(getShapeColor(by: card.content))
                            }
                            .frame(
                                width: geometry.size.width * ViewConstants.scale,
                                height: geometry.size.width * ViewConstants.scale / 2.5,
                                alignment: .center
                            )
                            .foregroundColor(card.content.color)
                        case .oval:
                            let capsule = Capsule()
                            
                            ZStack {
                                capsule.stroke()
                                capsule.fill().foregroundColor(getShapeColor(by: card.content))
                            }
                            .frame(
                                width: geometry.size.width * ViewConstants.scale,
                                height: geometry.size.width * ViewConstants.scale / 2.5,
                                alignment: .center
                            )
                            .foregroundColor(card.content.color)
                        }
                    }
                }
            }
            .foregroundColor(ViewConstants.defaultColor)
        }
    }
    
    private struct ViewConstants {
        static let scale: CGFloat = 0.7
        static let defaultStroke: Double = 1.5
        static let selectedStroke: Double = 3
        static let defaultColor: Color = .black
        static let selectedColor: Color = .cyan
        static let matchedColor: Color = .green
        static let notMatchedColor: Color = .red
    }
    
    func getShapeColor(by content: SetGameViewModel.CardContent) -> Color {
        switch content.shading {
        case .solid: return content.color
        case .striped: return content.color.opacity(0.3)
        case .open: return .white
        }
    }
    
    func getBorderColor() -> Color {
        switch card.matchingStatus {
        case .matched: return ViewConstants.matchedColor
        case .wrong: return ViewConstants.notMatchedColor
        case .unknown: return card.isSelected ? ViewConstants.selectedColor : ViewConstants.defaultColor
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        
        SetGameView(game: game)
    }
}
