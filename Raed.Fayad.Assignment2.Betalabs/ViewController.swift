//
//  ViewController.swift
//  Raed.Fayad.Assignment2.Betalabs
//
//  Created by Raed Fayad on 2018-11-07.
//  Copyright © 2018 Raed Fayad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = Set()
    private var visibleCardsIdentifiers = [0,1,2,3,4,5,6,7,8,9,10,11]
    private var gameStarted = false
    private var computerFoundMatch = false
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func touchedCard(_ sender: Any) {
        if gameStarted == false {
            gameStarted = true
            updateViewFromModel()
            startTimer()
            computerTextLabel.text = ""
            return
        }
        
        let returnedCards = game.checkForMatches()
        if returnedCards.count == 3 {
            if computerFoundMatch{
                game.score -= 4
                computerFoundMatch = false
            } else {
            game.score += 1
                computerTextLabel.text = "Good Job!"
                perform(#selector(performDelayedActionTwo), with: nil, afterDelay: 4.0)
            }
            for card in returnedCards{
                card.isMatched = true
            }
            startTimer()
            
        } else if returnedCards.count == 1 {
            game.score -= 1
            for card in game.cards{
                card.isSelected = false
            }
        }
        
        let cardIdentifier = visibleCardsIdentifiers[cardButtons.index(of: sender as! UIButton)!]
        
        if  game.cards[cardIdentifier].isSelected == false {
            game.cards[cardIdentifier].isSelected = true
        } else {
            game.cards[cardIdentifier].isSelected = false
        }
        updateViewFromModel()
        
    }
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var deckLabel: UILabel!
    @IBAction func newGamePressed(_ sender: Any) {
        game = Set()
        Card.identifierFactory = 0
        startTimer()
        visibleCardsIdentifiers = [0,1,2,3,4,5,6,7,8,9,10,11]
        for card in cardButtons {
            if cardButtons.index(of: card)!>11{
                card.isHidden = true
                card.isEnabled = false
                card.setImage(#imageLiteral(resourceName: "card back red"), for: .normal)
                card.setAttributedTitle(nil, for: .normal)
            }
        }
        drawThreeMoreCardsButton.isHidden = false
        numOfDraws = 0
        computerFoundMatch = false
        updateViewFromModel()
    }
    
    @IBOutlet weak var drawThreeMoreCardsButton: UIButton!
    private var numOfDraws = 0
    @IBAction func drawCardsPressed(_ sender: Any) {
        numOfDraws+=1
        let selectedSet = game.locateSet(maxIdentifier: visibleCardsIdentifiers.max()!)
        if selectedSet.count == 3{
            computerFoundMatch = false
            for card in selectedSet{
                card.isSelected = false
                card.isMatched = false
            }
            computerTextLabel.text = "You missed a set!"
            perform(#selector(performDelayedActionTwo), with: nil, afterDelay: 4.0)
            game.score -= 4
            updateViewFromModel()
        }
        if (80-visibleCardsIdentifiers.max()! >= 3){
            for _ in 0..<3 {
                visibleCardsIdentifiers.append(visibleCardsIdentifiers.max()! + 1)
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)!].isHidden = false
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)!].isEnabled = true
            }
            if numOfDraws > 3 {
                drawThreeMoreCardsButton.isHidden = true
            } else if numOfDraws == 1{
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 1].isHidden = false
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 1].isEnabled = false
            } else if numOfDraws == 2{
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 1].isHidden = false
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 1].isEnabled = false
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 2].isHidden = false
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 2].isEnabled = false
            } else if numOfDraws == 3{
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 1].isHidden = false
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 1].isEnabled = false
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 2].isHidden = false
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 2].isEnabled = false
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 3].isHidden = false
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)! + 3].isEnabled = false
                
            }
        } else {
            for _ in 0..<(80-visibleCardsIdentifiers.max()!) {
                visibleCardsIdentifiers.append(visibleCardsIdentifiers.max()! + 1)
                cardButtons[visibleCardsIdentifiers.index(of: visibleCardsIdentifiers.max()!)!].isHidden = false
            }
        }
        updateViewFromModel()
    }
    
    @IBOutlet weak var computerEmojiLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!{
        didSet{
            countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            countdownTimer.invalidate()
        }
    }
    
    private var countdownTimer: Timer!
    private var totalTime = 60
    
    private func startTimer() {
        countdownTimer.invalidate()
        totalTime = 60
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        updateTime()
    }
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    private func endTimer() {
        countdownTimer.invalidate()
        startTimer()
        updateViewFromModel()
        let selectedSet = game.locateSet(maxIdentifier: visibleCardsIdentifiers.max()!)
        if selectedSet.count == 3{
            countdownTimer.invalidate()
            computerFoundMatch = true
            computerEmojiLabel.text = "😂"
            computerTextLabel.text = "I got it!"
            updateViewFromModel()
            perform(#selector(performDelayedAction), with: nil, afterDelay: 4.0)
        }
        
    }
    @objc func performDelayedAction() {
        computerEmojiLabel.text = "🧐"
        computerTextLabel.text = ""
        let returnedCards = game.checkForMatches()
        if returnedCards.count == 3 {
            if computerFoundMatch{
                game.score -= 4
                computerFoundMatch = false
            } else {
                game.score += 4
            }
            for card in returnedCards{
                card.isMatched = true
            }
            startTimer()
            computerFoundMatch = false
            computerTextLabel.text = "Keep trying!"
            perform(#selector(performDelayedActionTwo), with: nil, afterDelay: 2.0)
            updateViewFromModel()
        }
    }
    @objc func performDelayedActionTwo() {
        computerTextLabel.text = ""
    }
    
   private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: " Timer: %02d", seconds)
    }
    
    @IBOutlet weak var computerTextLabel: UILabel!
    
    let shapeOptions = ["●","■","▲"]
    let shadeOptions = [-5, 0, 5]
    let fillOptions = [1,0.25,0]
    let colorOptions = [UIColor.red, UIColor.purple, UIColor.green]
    
    private func updateViewFromModel()
    {
        for card in 0..<visibleCardsIdentifiers.count{
            if game.cards[visibleCardsIdentifiers[card]].isMatched{
                game.cards[visibleCardsIdentifiers[card]].isSelected = false
                visibleCardsIdentifiers[card] = visibleCardsIdentifiers.max()! + 1
            }
            if visibleCardsIdentifiers[card] >= 81{
                cardButtons[card].isEnabled = false
                game.cards[visibleCardsIdentifiers[card]].isSelected = false
                cardButtons[card].setAttributedTitle(nil, for: .normal)
                cardButtons[card].setTitle(nil, for: .normal)
                cardButtons[card].layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                continue
            }
            cardButtons[card].layer.borderWidth = 3.0
            cardButtons[card].layer.cornerRadius = 8.0
            cardButtons[card].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            if game.cards[visibleCardsIdentifiers[card]].isSelected {
                cardButtons[card].layer.borderColor = UIColor.purple.cgColor
            } else {
                cardButtons[card].layer.borderColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 0.3771136558)
            }
            cardButtons[card].setImage(nil, for: .normal)
            var attributedText = NSMutableAttributedString(string: shapeOptions[game.cards[visibleCardsIdentifiers[card]].shape], attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24),NSAttributedStringKey.strokeWidth: -5,NSAttributedStringKey.foregroundColor: colorOptions[game.cards[visibleCardsIdentifiers[card]].color].withAlphaComponent(CGFloat(fillOptions[game.cards[visibleCardsIdentifiers[card]].shading])), NSAttributedStringKey.strokeColor:colorOptions[game.cards[visibleCardsIdentifiers[card]].color], ])
            cardButtons[card].titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cardButtons[card].titleLabel?.numberOfLines = 0
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.8
            if game.cards[visibleCardsIdentifiers[card]].numOfSymbols == 0 {
            } else if game.cards[visibleCardsIdentifiers[card]].numOfSymbols == 1 {
                attributedText = attributedText + attributedText
            } else if game.cards[visibleCardsIdentifiers[card]].numOfSymbols == 2 {
                attributedText = attributedText + attributedText + attributedText
            }
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
            cardButtons[card].setAttributedTitle(attributedText, for: .normal)
            
            deckLabel.text = "Deck: \(80-visibleCardsIdentifiers.max()!)"
            scoreLabel.text = "Score: \(game.score)"
            if(80-visibleCardsIdentifiers.max()! == 0){
                drawThreeMoreCardsButton.isHidden = true
            }
            
        }
    }
}

extension NSMutableAttributedString {
    static func +(lhs: NSMutableAttributedString, rhs: NSMutableAttributedString) -> NSMutableAttributedString {
        let combination = NSMutableAttributedString()
        combination.append(lhs)
        combination.append(NSMutableAttributedString(string: "\n"))
        combination.append(rhs)
        return combination
    }
}

extension Int {
    var arc4random : Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
