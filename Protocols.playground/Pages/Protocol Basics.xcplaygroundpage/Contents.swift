import Foundation

//: # Protocols
//: Protocols are, as per Apple's definition in the _Swift Programming Language_ book:
//:
//: "... a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements. Any type that satisfies the requirements of a protocol is said to conform to that protocol."
//:
//: The below example shows a protocol that requires conforming types have a particular property defined.

// these are the rules for anyone that wants to have a full name
protocol FullyNamed {
                        // desides wether it is read only({get}) or read/write({get set})
    var fullName: String { get }
}

// getters and setters

// get-only properties are computed properties
var randomNumber: Int {
    get{
        print("getting random number")
        return Int.random(in: 1...100)
    }
    
    // runs when you try to set the value of the variable
    set {
        // newValue comes with the set method
        print("the value is being set to \(newValue)")
    }
}

struct Person: FullyNamed {
    
    // conforms to protocol here
    var fullName: String
    var favoriteColor: String
    
}

struct StarShip: FullyNamed {
    var prefix: String?
    var name: String
    //check to see if starship has a prefix.  if so add to name otherwise return full name
    var fullName: String {
        get {
            if let prefix = prefix {
                return prefix + " " + name
            }else {
                return name
            }
        }
    }
}

//: Protocols can also require that conforming types implement certain methods.

protocol GeneratesRandomNumbers {
     func random() -> Int
}

class OneThroughTen: GeneratesRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
}

//: Using built-in Protocols

let me = Person(fullName: "Chris", favoriteColor: "blue")
let sam = Person(fullName: "Sam", favoriteColor: "red")

// extenson allows us to extend the functionality of a data type without going back to the original
extension Person: Equatable {
    static func == (lhs:Person, rhs: Person) -> Bool {
        // determione how we want one person to equal another one
//        if lhs.fullName == rhs.fullName {
//            return true
//        }else{
//            return false
//        }
        return lhs.fullName == rhs.fullName
    }
}

if me == sam {
    print("thesame")
}

//: ## Protocols as Types


class Dice {
    let sides: Int
    let generator: GeneratesRandomNumbers
    
    init(sides: Int, generator: GeneratesRandomNumbers) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        let rolledNumber = generator.random() % sides + 1
        return rolledNumber
    }
}

