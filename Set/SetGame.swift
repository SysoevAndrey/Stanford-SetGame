//
//  SetGame.swift
//  Set
//
//  Created by Andrey Sysoev on 11.06.2022.
//

import Foundation

struct SetGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var cardsCount: Int
    private var compareContent: (CardContent, CardContent, CardContent) -> Bool
    
    let cardsCountInitialValue = 12
    
    enum MatchingStatus {
        case matched, wrong, unknown
    }
    
    struct Card: Identifiable {
        var isSelected = false
        var isVisible = true
        var matchingStatus: MatchingStatus = .unknown
        let content: CardContent
        let id: Int
    }
    
    init(
        numberOfCards: Int,
        createCardContent: (Int) -> CardContent,
        compareCardsContent: @escaping (CardContent, CardContent, CardContent) -> Bool
    ) {
        cards = []
        cardsCount = cardsCountInitialValue
        compareContent = compareCardsContent
        
        for index in 0..<numberOfCards {
            let content = createCardContent(index)
            
            cards.append(Card(content: content, id: index))
        }
        
        cards.shuffle()
    }
    
    var selectedCards: Array<Int> {
        get { cards.indices.filter { cards[$0].isSelected } }
        set { cards.indices.forEach { cards[$0].isSelected = ($0 == newValue.first) } }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           cards[chosenIndex].matchingStatus != .matched
        {
            if selectedCards.count == 2 {
                let first = selectedCards[0]
                let second = selectedCards[1]
                
                if compareContent(cards[first].content, cards[second].content, cards[chosenIndex].content) {
                    cards[first].matchingStatus = .matched
                    cards[second].matchingStatus = .matched
                    cards[chosenIndex].matchingStatus = .matched
                } else {
                    cards[first].matchingStatus = .wrong
                    cards[second].matchingStatus = .wrong
                    cards[chosenIndex].matchingStatus = .wrong
                }
                
                cards[chosenIndex].isSelected = true
            } else if selectedCards.count == 3 {
                cards.indices.forEach { cards[$0].matchingStatus = (cards[$0].matchingStatus == .matched ? .matched : .unknown) }
                
                if selectedCards.allSatisfy({ cards[$0].matchingStatus == .matched }) {
                    cards.indices.filter({ cards[$0].matchingStatus == .matched }).forEach({ cards[$0].isVisible = false })
                    addThreeCards()
                }
                
                selectedCards = [chosenIndex]
            } else {
                cards[chosenIndex].isSelected.toggle()
            }
    
        }
    }
    
    mutating func addThreeCards() {
        if cards.count >= cardsCount + 3 {
            cardsCount += 3
        }
    }
    
    mutating func startNewGame() {
        cards.indices.forEach {
            cards[$0].matchingStatus = .unknown
            cards[$0].isVisible = true
        }
        
        selectedCards = []
        cards.shuffle()
        cardsCount = cardsCountInitialValue
    }
}
