//
//  SetGameViewModel.swift
//  Set
//
//  Created by Andrey Sysoev on 11.06.2022.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    typealias Card = SetGame<CardContent>.Card
    
    enum Shape: Int, CaseIterable {
        case diamond, squiggle, oval
    }
    
    enum Shading: Int, CaseIterable {
        case solid, striped, open
    }
    
    struct CardContent: Equatable {
        let shape: Shape
        let numberOfShapes: Int
        let shading: Shading
        let color: Color
    }
    
    static let shapes: [Shape] = [.diamond, .squiggle, .oval]
    static let shadings: [Shading] = [.solid, .striped, .open]
    static let colors: [Color] = [.green, .red, .purple]
    
    private static func createSetGame() -> SetGame<CardContent> {
        SetGame<CardContent>(numberOfCards: 81) { cardIndex in
            let shapeIndex = cardIndex % 3
            let numberOfShapesIndex = (cardIndex / 3) % 3
            let shadingIndex = (cardIndex / 3 / 3) % 3
            let colorIndex = (cardIndex / 3 / 3 / 3) % 3

            let numberOfShapes = numberOfShapesIndex + 1
            
            let shape = shapes[shapeIndex]
            let shading = shadings[shadingIndex]
            let color = colors[colorIndex]
            
            return CardContent(
                shape: shape,
                numberOfShapes: numberOfShapes,
                shading: shading,
                color: color
            )
        } compareCardsContent: { first, second, third in
            func compareProperty<T: Equatable>(_ first: T, _ second: T, _ third: T) -> Bool {
                if (first == second && first == third && second == third) || (first != second && first != second && second != third) {
                    return true
                }

                return false
            }
            
            var shapeMatched = false
            var numberOfShapesMatched = false
            var shadingMatched = false
            var colorMatched = false
            
            if compareProperty(first.shape, second.shape, third.shape) {
                shapeMatched = true
            }

            if compareProperty(first.numberOfShapes, second.numberOfShapes, third.numberOfShapes) {
                numberOfShapesMatched = true
            }

            if compareProperty(first.shading, second.shading, third.shading) {
                shadingMatched = true
            }

            if compareProperty(first.color, second.color, third.color) {
                colorMatched = true
            }
            
            return shapeMatched && numberOfShapesMatched && shadingMatched && colorMatched
        }
    }
    
    @Published private var setGame = createSetGame()
    
    var cards: Array<Card> {
        Array(setGame.cards.prefix(setGame.cardsCount).filter({ $0.isVisible }))
    }
    
    var cardsCount: Int {
        setGame.cardsCount
    }
    
    func addThreeCards() {
        setGame.addThreeCards()
    }
    
    func startNewGame() {
        setGame.startNewGame()
    }
    
    func choose(card: Card) {
        setGame.choose(card: card)
    }
}
