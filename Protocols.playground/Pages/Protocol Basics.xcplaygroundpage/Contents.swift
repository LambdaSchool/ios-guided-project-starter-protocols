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

let johnny = Person( fullName: "Johnny Hicks")
let spencer = Person(fullName: "Spencer Curtis")

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix}
        
    // Computed property - run a calculation when calling the getter
    var fullName: String {
//            if prefix == nil {
//                return name
//            } else {
//                prefix! + " " + name
//            }
            return (prefix != nil ? prefix! + " " : "") + name
        }
    }


var ncc1701 =  Starship(name: "Enterprise", prefix: "USS")
ncc1701.fullName

var firefly = Starship(name: "Serenity")
firefly.fullName
//: Protocols can also require that conforming types implement certain methods.

protocol GenerateRandomNumbers {
    func random() -> Int
}

/// Generates a random numer on call
class OneThroughTen: GenerateRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
}

class OneThroughOneHundred: GenerateRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...100)
    }
}

let rand = OneThroughTen()
rand.random()

let rand2 = OneThroughOneHundred()
rand2.random()

//: Using built-in Protocols - Equatable can be == or !=

extension Starship: Equatable {
    static func == (lhs: Starship, rhs: Starship) -> Bool {
        if lhs.fullName == rhs.fullName {
            return true
        }
        return false
    }
}

if ncc1701 == firefly {
    print("The ships are the same")
} else {
    print("The ships are different")
}




//: ## Protocols as Types

class Dice {
    let sides: Int
    let generator: GenerateRandomNumbers
    
    init(sides: Int, generator: GenerateRandomNumbers) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        let remainder = generator.random() % sides
        return remainder + 1
    }
}

var d6 = Dice(sides: 6, generator: OneThroughTen())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}
// Shapes
// Shape class
// Circle: Shape
// Triangle: Shape

// let shapesArray: [Shapes] = [circle, triangle]

