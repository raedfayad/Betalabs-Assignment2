//
//  Card.swift
//  Raed.Fayad.Assignment2.Betalabs
//
//  Created by Raed Fayad on 2018-11-10.
//  Copyright © 2018 Raed Fayad. All rights reserved.
//

import Foundation

class Card : Hashable{
   
    var hashValue: Int { return identifier}
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return (lhs.color==rhs.color && lhs.shading==rhs.shading && lhs.shape==rhs.shape && lhs.numOfSymbols==rhs.numOfSymbols)
    }
    
    var isSelected = false
    var isMatched = false
    private var identifier: Int
    
    private (set) var shape: Int
    private (set) var shading: Int
    private (set) var color: Int
    private (set) var numOfSymbols: Int
    
    static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        if identifierFactory >= 81 {
            return -1
        }
        return identifierFactory
    }
    
    init(){
        self.identifier = Card.getUniqueIdentifier()
        self.color = 3.arc4random
        self.shape = 3.arc4random
        self.shading = 3.arc4random
        self.numOfSymbols = 3.arc4random

    }
}
