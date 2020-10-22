import Foundation
//: We're building a dice game called _Knock Out!_. It is played using the following rules:
//: 1. Each player chooses a “knock out number” – either 6, 7, 8, or 9. More than one player can choose the same number.
//: 2. Players take turns throwing both dice, once each turn. Add the number of both dice to the player's running score.
//: 3. If a player rolls their own knock out number, they are knocked out of the game.
//: 4. Play ends when either all players have been knocked out, or if a single player scores 100 points or higher.
//:
//: Let's reuse some of the work we defined from the previous page.

protocol GeneratesRandomNumbers {
    func random() -> Int
}

class OneThroughTen: GeneratesRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
}

class Dice {
    let sides: Int
    let generator: GeneratesRandomNumbers
    
    init(sides: Int, generator: GeneratesRandomNumbers) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() % sides) + 1
    }
}

//: Now, let's define a couple protocols for managing a dice-based game.

protocol DiceGame {
    var dice: Dice { get }
    func play()
}


//: Lastly, we'll create a custom class for tracking a player in our dice game.

class Player {
    var id: Int
    let knockOutNumber: Int
    var score = 0
    var isKnockedOut = false
    
    init(id:Int) {
        self.id = id
        self.knockOutNumber = Int.random(in: 6...9)
    }
}


//: With all that configured, let's build our dice game class called _Knock Out!_

class KnockOut: DiceGame {
    var dice: Dice = Dice(sides: 6, generator: OneThroughTen())
    var players: [Player] = []
    
    init(numberOfPlayers: Int){
        for playerId in 1...numberOfPlayers {
            let player = Player(id: playerId)
            players.append(player)
        }
    }
    
    func play() {
        var gameHasEnded = false
        
        while gameHasEnded == false {
            for player in players {
                guard player.isKnockedOut == false else { continue }
                let diceRoll = dice.roll() + dice.roll()
                if diceRoll == player.knockOutNumber {
                    print("player \(player.id) is out")
                    player.isKnockedOut = true
                    
                }else {
                    player.score += diceRoll
                    if player.score >= 100 {
                        gameHasEnded = true
                        print("player \(player.id) has won")
                        break
                    }
                }
            }
        }
    }
}


//: Finally, we need to test out our game. Let's create a game instance, add a tracker, and instruct the game to play.



