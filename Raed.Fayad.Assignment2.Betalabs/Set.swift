//
//  Set.swift
//  Raed.Fayad.Assignment2.Betalabs
//
//  Created by Raed Fayad on 2018-11-10.
//  Copyright © 2018 Raed Fayad. All rights reserved.
//

import Foundation

class Set {
    
    //use closure for going through the entire deck and filtering through it
    
    private(set) var cards = [Card]()
    var score = 0
    private var initTime: Date
    
    init(){
        initTime = Date()
        cards = [Card]()
        cards.append(Card())
        Card.identifierFactory += 1

        for _ in  0..<81{
            var newCard = Card()
            for card in cards {
                while (card == newCard){
                    newCard = Card()
                }
            }
            cards.append(newCard)
        }
    }
    
    func checkForMatches() -> [Card]{
        var selectedCards = [Card]()
        for card in cards {
            if card.isSelected {
                selectedCards.append(card)
            }
        }
        
        if selectedCards.count == 3{
            let a = selectedCards[0]
            let b = selectedCards[1]
            let c = selectedCards[2]
            if (a.color == b.color && b.color == c.color)||(a.color != b.color && b.color != c.color && c.color != a.color){
                if (a.shape == b.shape && b.shape == c.shape)||(a.shape != b.shape && b.shape != c.shape && c.shape != a.shape){
                    if (a.shading == b.shading && b.shading == c.shading)||(a.shading != b.shading && b.shading != c.shading && c.shading != a.shading){
                        if (a.numOfSymbols == b.numOfSymbols && b.numOfSymbols == c.numOfSymbols)||(a.numOfSymbols != b.numOfSymbols && b.numOfSymbols != c.numOfSymbols && c.numOfSymbols != a.numOfSymbols){
                            return selectedCards
                        }
                    }
                    
                }
            }
            
            for card in 0..<selectedCards.count{
                selectedCards[card].isSelected = false
            }
            return [a]
        }
        return []
    }
    
    func locateSet(maxIdentifier: Int) -> [Card] {
        
        for card in cards{
            card.isSelected = false
        }
        var cardsToCheck = [Card]()
        for n in 0..<maxIdentifier+1{
            cardsToCheck.append(cards[n])
        }
        for i in cardsToCheck{
            if i.isMatched == true {
                continue
            }
            i.isSelected = true
            for j in cardsToCheck {
                if (j.isMatched == true || j == i){
                    continue
                } else {
                    j.isSelected = true
                    for k in cardsToCheck{
                        if (k.isMatched == true || j == k || k == i ){
                            continue
                        } else {
                            i.isSelected = true
                            j.isSelected = true
                            k.isSelected = true
                            if checkForMatches().count == 3 {
                                //i.isSelected = false
                                //j.isSelected = false
                                //k.isSelected = false
                                return [i,j,k]
                            }
                            k.isSelected = false
                        }
                        
                    }
                    j.isSelected = false
                }
            }
            i.isSelected = false
        }
        return []
    }
}
