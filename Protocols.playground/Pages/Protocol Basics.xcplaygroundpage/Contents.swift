import Foundation

//: # Protocols
//: Protocols are, as per Apple's definition in the _Swift Programming Language_ book:
//:
//: "... a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements. Any type that satisfies the requirements of a protocol is said to conform to that protocol."
//:
//: The below example shows a protocol that requires conforming types have a particular property defined.

protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    var fullName: String
}

let joe = Person(fullName: "Joseph Rogers")

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    var fullName: String {
        //        var validPrefix: String
        //        if prefix != nil {
        //            validPrefix = prefix!
        //        }else {
        //            validPrefix = ""
        //        }
        //        return validPrefix + " " + name
        //    }
        return (prefix != nil ? prefix! + " " : "") + name
    }
}

var myShip = Starship(name: "Enterprise", prefix: "USS")

myShip.fullName

var firefly = Starship(name: "firefly")
firefly.fullName

//: Protocols can also require that conforming types implement certain methods.

protocol GeneratesRandomNumbers {
    func random() -> Int
}

class OneThroughTen : GeneratesRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
}

let randomNumber = OneThroughTen()
randomNumber.random()
randomNumber.random()

extension Starship: Equatable {
   public static func == (lhs: Starship, rhs: Starship) -> Bool {
//        if lhs.fullName == rhs.fullName{
//            return true
//        }else {
//            return false
//        }
    return lhs.fullName == rhs.fullName
    }
    
    
}


if myShip == firefly {
    print("Same Starship!")
}else{
    print("Not the same Starship!")
}

//: ## Protocols as Types


class Dice {
    let sides: Int
    let generator: GeneratesRandomNumbers
    
    init(sides: Int, generator: GeneratesRandomNumbers) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int { // 10 / 6 = remainder of
        return (generator.random() % sides) + 1 //turns 0 to 5 to 1 to 6
    }
}


var d6 = Dice(sides: 6, generator: OneThroughTen())
for _ in 1...5 {
    print("Random Dice roll is \(d6.roll())")
}

class EvenThroughTwenty : GeneratesRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10) * 2 - 1
    }
}

var d6AlwaysEven = Dice(sides: 6, generator: EvenThroughTwenty())
for _ in 1...5 {
    print("Random Dice roll is \(d6AlwaysEven.roll())")
}
