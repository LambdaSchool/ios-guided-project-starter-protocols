import Foundation
//: We're building a dice game called _Knock Out!_. It is played using the following rules:
//: 1. Each player chooses a “knock out number” – either 6, 7, 8, or 9. More than one player can choose the same number.
//: 2. Players take turns throwing both dice, once each turn. Add the number of both dice to the player's running score.
//: 3. If a player rolls their own knock out number, they are knocked out of the game.
//: 4. Play ends when either all players have been knocked out, or if a single player scores 100 points or higher.
//:
//: Let's reuse some of the work we defined from the previous page.



protocol GeneratesRandomNumbers { //here we are creating a protocol which can generate numbers. it only needs to have the placeholders
    func random() -> Int
}

class OneThroughTen: GeneratesRandomNumbers { //this is the numbers we will be going through with the generator confromed to it!
    func random() -> Int {
        
        return Int.random(in: 1...10) //our generator just uses swifts built in random generator
    }
}

class Dice: CustomStringConvertible {
    let sides: Int
    let generator: GeneratesRandomNumbers
    
    var description: String {
        return "\(sides)- sided dice"
    }
    
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
    var dice: Dice {get}
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, player: Player, didStartNewTrunWithDiceRoll diceRoll: Int)
    func gamedidend(_ game: DiceGame)
}

//: Lastly, we'll create a custom class for tracking a player in our dice game.

class Player {
    var id: Int
    let knockOutNumber: Int = Int.random(in: 6...9)
    var score: Int = 0
    var knockedOut: Bool = false
    
    init(id: Int) {
        self.id = id
    }
}

//: With all that configured, let's build our dice game class called _Knock Out!_

class KnockOut: DiceGame {
    let dice: Dice = Dice(sides: 6, generator: OneThroughTen())
    var players = [Player]()
    
    init(numberOfPlayers: Int) {
        for i in 1...numberOfPlayers {
            let aPlayer = Player(id: i)
            players.append(aPlayer)
        }
    }
    
    var delegate: DiceGameDelegate?
    
    func play() {
        
        delegate?.gameDidStart(self)
        var reachedEndOfGame = false
        
        
        while reachedEndOfGame == false {
            for player in players where player.knockedOut == false {
                //creating type of diceroll, which is two rolls.
                let diceRollSum = dice.roll() + dice.roll()
                
                delegate?.game(self, player: player, didStartNewTrunWithDiceRoll: diceRollSum)
                //if you roll your number you are knocked out and this gets called
                if diceRollSum == player.knockOutNumber {
                    print("Player \(player.id) is knocked out from rolling: \(player.knockOutNumber)")
                    player.knockedOut = true
                    //were creating a filtered array that has only active players
                    let activePlayers = players.filter { $0.knockedOut == false }
                    if activePlayers.isEmpty {
                        reachedEndOfGame = true
                        print("All players have been knocked out!")
                    }
                }else {
                    player.score += diceRollSum
                    if player.score >= 100 {
                        reachedEndOfGame = true
                        print("Player \(player.id) has won with a final score of \(player.score.description).")
                        break
                    }
                }
            }
       
           
    }
         delegate?.gamedidend(self)
    }
}

//: The following class is used to track the status of the above game, and will conform to the `DiceGameDelegate` protocol.

class DiceGameTracker: DiceGameDelegate {
   
    
    var numberOfTurns: Int = 0
    
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is KnockOut {
            print("Started a new game of Knock Out.")
        }
        print("The game is using a \(game.dice)")
    }
    
    func game(_ game: DiceGame, player: Player, didStartNewTrunWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Player \(player.id) rolled a \(diceRoll)")
    }
    
    func gamedidend(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns. ")
    }
    
    
}

//: Finally, we need to test out our game. Let's create a game instance, add a tracker, and instruct the game to play.
let tracker = DiceGameTracker()
let game = KnockOut(numberOfPlayers: 5)
game.delegate = tracker
game.play()
