//
//  main.swift
//  SnipSnapSnorem
//
//  Created by Dovgalyk, Dima on 2020-03-05.
//  Copyright © 2020 Dovgalyk, Dima. All rights reserved.
//

import Foundation


class SnipSnapSnorem {
    //the following set up was provided by Joven Peralta (until *end*)
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
    // *end*
    
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
        
        //bubble search algorithm was provided by Mr. Gordon during class time
        for i in 0..<computer.cards.count - 1 {
            //one pass through the array to float the highest number to the end
            for j in 0..<computer.cards.count - 1 {
            
                //compare the left value to the right value
                if computer.cards[j].rank.rawValue > computer.cards[j+1].rank.rawValue {
                    //swap the values when left value is more than right value
                    let temporaryValue = computer.cards[j]//set aside the left value

                    computer.cards[j] = computer.cards[j+1] //replace left with right
                    computer.cards[j+1] = temporaryValue //replace right with left
                }
            }

        }
        //bubble sorting algorith to sort players cards.
        
        for i in 0..<player.cards.count - 1 {
            //one pass through the array to float the highest number to the end

            for j in 0..<player.cards.count - 1 {
            
                //compare the left value to the right value
                if player.cards[j].rank.rawValue > player.cards[j+1].rank.rawValue {
                    //swap the values when left value is more than right value
                    let temporaryValue = player.cards[j]//set aside the left value

                    player.cards[j] = player.cards[j+1] //replace left with right
                    player.cards[j+1] = temporaryValue //replace right with left
                }
            }

        }
        
        
        while playInMotion == true {
            //check the end of the game
            end()
            //keeps track of total hands played
            totalHandsPlayed += 1
            
            // Player plays their top card
            middlePile.cards.append(offence.dealTopCard()!)
            
            // Makes the round card value
            let roundCard = middlePile.topCard?.rank
            //play the hand
            for _ in 0...4 {
                //if the offence has the card that is currently at play then place the card
                if offence.cards[0].rank == roundCard {
                    //check if they still have cards to append
                    if offence.cards.count > 1 {
                        middlePile.cards.append(offence.cards[0])
                        offence.cards.remove(at: 0)
                    }
                    
                }
            }
            //statistics
            if offence === computer {
                
                print("📕: Computer has \(computer.cards.count) cards left")
            } else if offence === player {
                print("📗: Player has \(player.cards.count) cards left")

            }
            //defence checks if they have the same value
            //if they do they place the card
            if defence.cards[0].rank == roundCard  {
                for _ in 0...4 {
                    if defence.cards[0].rank == roundCard  {
                        if defence.cards.count > 1 {

                            middlePile.cards.append(defence.cards[0])
                            defence.cards.remove(at: 0)
                        }
                    }
                }
                //change who is offence and who is defence
                canDefenceRespond = true
            }
            //statistics
            if defence === computer {
                print("📕: Computer has \(computer.cards.count) cards left")
            } else if defence === player {
                print("📗: Player has \(player.cards.count) cards left")

            }
            
           
            // If defence responded, swap who is playing first
            if canDefenceRespond == true {
                changeWhoIsOnOffence()
            } else {
                if offence === computer {
                    handsWonComputer += 1
                    print("📕: The computer won \(handsWonComputer) hands")
                } else if offence === player {
                    handsWonPlayer += 1
                    print("📗: The player won \(handsWonPlayer) hands")
                }
            }
            print("📓: Total hands played \(totalHandsPlayed)")
            print("📓:")
            //check the end
            end()
            //clear the middle pile
            middlePile.cards.removeAll()
            
            
            
        }
        
        
        
    }
  
    
    // Change who is on offence and who is on defence
    
    func changeWhoIsOnOffence() {
        // If the player is on offence
        if player === offence {
            // Make computer offence and player defence
            offence = computer
            defence = player
            //if the player goes in to defence, it means that the computer has won
            
            handsWonComputer += 1
            print("📕: The computer won \(handsWonComputer) hands") //*modified*
            
            
        // If the computer is on offence
        } else if player === defence {
            
            // Make player offence and computer defence
            offence = player
            defence = computer
            //if the computer switches to defence, it mens that the player has won
            
            handsWonPlayer += 1 //*modified*
            print("📗: The player won \(handsWonPlayer) hands") //*modified*
            
        }
        
        //switch the statement back to false
        canDefenceRespond = false //*modified*
        
    }
    
    func end(){
        if computer.cards.count <= 1 || player.cards.count <= 1 {
            
            playInMotion = false
            //if computer has less cards it won
            if computer.cards.count <= 1 {
                print("📕: The computer has won the game")
                //if the player has less cards they won
            } else if player.cards.count <= 1 {
                print("📗: The player has won the game")

            } else {
                print("📓: It's a tie")
            }
        }
    }
    
    
}
SnipSnapSnorem()

