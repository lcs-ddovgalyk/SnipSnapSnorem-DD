//
//  main.swift
//  SnipSnapSnorem
//
//  Created by Peralta, Joven on 2020-03-05.
//  Copyright © 2020 Peralta, Joven. All rights reserved.
//

import Foundation


class SnipSnapSnorem {
    // Instance variables
    // The deck of cards
    var deck : Deck
    
    // The hands for each player
    var player : Hand
    var computer : Hand
    
    // The pile where each player shows their cards
    var middlePile : Hand
    
    // Offence is the person who plays their card first
    var offence: Hand
    
    // Defence is the person who has to play a matching card
    var defence: Hand
    
    // Determines if person on defence can respond to the player on offence
    var canDefenceRespond: Bool
    
    var handsWonComputer = 0
    var handsWonPlayer = 0
    var totalHandsPlayed = 0
    var playInMotion: Bool

    
    // Initializers
    init () {
        // Initialize the initial deck (deck that gets shuffled and dealt out to the players)
        deck = Deck()

        // Initialize the player hands
        player = Hand(description: "Player's hand")
        computer = Hand(description: "Computer's hand")
        
        // Initialize the middle pile
        middlePile = Hand(description: "Middle pile")
        
        
        // Deal to the player
        if let newCards = self.deck.randomlyDealOut(thisManyCards: 26) {
            player.cards = newCards
        }
        
        // Deal to the computer
        if let newCards = self.deck.randomlyDealOut(thisManyCards: 26) {
            computer.cards = newCards
        }
        
        // Middle pile has no cards to start with
        middlePile.cards = []
        
        // Player is on offence at start (plays first)
        offence = player
        defence = computer
        
        canDefenceRespond = false
        playInMotion = true
        play()
        
        
    }

    func play() {
        if playInMotion == true {
            //keeps track of total hands played
            totalHandsPlayed += 1
            // Player plays their top card
            middlePile.cards.append(offence.dealTopCard()!)
            
            // Makes the round card value
            let roundCard = middlePile.topCard?.rank
            
            // Search the hand of the player on offence
            for a in 1...offence.cards.count {
             
                
                // If it finds a card of the same value as the one just played
                if offence.cards[a].rank == roundCard {
                    // Play the card
                    middlePile.cards.append(offence.cards[a])
                    //prints how many cards the computer or the player has
                    if offence === player {
                        print("Player has \(offence.cards.count) cards left")
                    } else if offence === computer {
                        print("Computer has \(offence.cards.count) cards left")
                    }
                    
                    
                }
            
                
            }
            //check if the defence has the same card that was placed
            for b in 1...defence.cards.count {
                
                //if it finds a card of the same value place it in the middle pile
                if defence.cards[b].rank == roundCard {
                    middlePile.cards.append(defence.cards[b])
                    //set the defence to true
                    //if defence doesn't find the same value, the positions stay the same
                    canDefenceRespond = true
                    //prints how many cards the computer or the player has
                    if defence === player {
                    } else if defence === computer {
                        print("Computer has \(defence.cards.count) cards left")
                    }
                    
                }
            
            }
            
            // If defence responded, swap who is playing first
            if canDefenceRespond == true {
                changeWhoIsOnOffence()
            }
            end()
        }
        
        
        
    }
  
    
    // Change who is on offence and who is on defence
    func changeWhoIsOnOffence() {
        // If the player is on offence
        if offence === player {
            // Make computer offence and player defence
            offence = computer
            defence = player
            //if the player goes in to defence, it means that the computer has won
            
            handsWonComputer += 1
            print("The computer won \(handsWonComputer) hands")
            
            
        // If the computer is on offence
        } else {
            
            // Make player offence and computer defence
            offence = player
            defence = computer
            //if the computer switches to defence, it mens that the player has won
            
            handsWonPlayer += 1
            print("The player won \(handsWonPlayer) hands")
            
        }
        
        
    }
    
    func end(){
        if offence.cards.count == 1 && defence.cards.count == 1 {
            print("")
            playInMotion = false
        }
    }
    
    
}

SnipSnapSnorem()

