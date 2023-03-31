import Foundation

//This is a Swift program that simulates a game of poker. It defines several structures and enums to represent a deck of cards, a hand of cards, and the rank of a hand.

//The Suit and Rank enums represent the suits and ranks of the cards, respectively. The Card struct has two properties: the suit and the rank of the card.

//The Hand struct represents a hand of cards, which is an array of Card objects. It has a computed property called rankValue, which calculates the rank of the hand based on its contents. The compare(to:) method can be used to compare two hands and determine the winner.

//The Result enum represents the outcome of a game, and has three cases: player1Wins, player2Wins, and tie.

//The main part of the program reads in a file called "poker-hands.txt", which contains a list of hands of cards, one per line. It then iterates over the list of hands, compares them using the compare(to:) method, and updates the win counts for each player accordingly. Finally, it prints out the number of wins for each player.

enum Suit: String {
    case diamonds = "D", hearts = "H", clubs = "C", spades = "S"
}

enum Rank: Int {
    case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}

struct Card {
    let suit: Suit
    let rank: Rank
}

struct Hand {
    private let cards: [Card]

    init(_ cardStrings: [String]) {
        cards = cardStrings.compactMap { cardString -> Card? in
            guard let suitString = cardString.last,
                  let suit = Suit(rawValue: String(suitString)),
                  let rankString = cardString.dropLast().description,
                  let rankValue = Int(rankString),
                  let rank = Rank(rawValue: rankValue)
            else {
                return nil
            }
            return Card(suit: suit, rank: rank)
        }
    }

    var rankValue: Int {
        let values = cards.map { $0.rank.rawValue }.sorted(by: >)
        let isFlush = cards.allSatisfy { $0.suit == cards[0].suit }
        let isStraight = values == Array(values[0]...values[4]) || values == [Rank.ace.rawValue, Rank.two.rawValue, Rank.three.rawValue, Rank.four.rawValue, Rank.five.rawValue]
        let counts = Dictionary(grouping: values, by: { $0 }).mapValues { $0.count }
        let isFullHouse = counts.values.sorted() == [2, 3]
        let isThreeOfAKind = counts.values.contains(3)
        let isTwoPair = counts.values.sorted() == [1, 2, 2]
        let isPair = counts.values.contains(2)
        if isFlush && isStraight && values.contains(Rank.ace.rawValue) {
            return 10 // Royal flush
        } else if isFlush && isStraight {
            return 9 // Straight flush
        } else if isFourOfAKind(counts: counts) {
            return 8 // Four of a kind
        } else if isFullHouse {
            return 7 // Full house
        } else if isFlush {
            return 6 // Flush
        } else if isStraight {
            return 5 // Straight
        } else if isThreeOfAKind {
            return 4 // Three of a kind
        } else if isTwoPair {
            return 3 // Two pairs
        } else if isPair {
            return 2 // Pair
        } else {
            return 1 // High card
        }
    }

    private func isFourOfAKind(counts: [Int: Int]) -> Bool {
        counts.values.contains(4)
    }
}

enum Result {
    case player1Wins(highestCard: Rank)
    case player2Wins(highestCard: Rank)
    case tie(highestCard: Rank)
}

extension Hand {
    var highestRank: Rank {
        cards.max { $0.rank.rawValue < $1.rank.rawValue }?.rank ?? .two
    }

    func valuesSortedByCount() -> [(value: Int, count: Int)] {
        var dictionary = [Rank: Int]()
        cards.forEach { card in
            dictionary[card.rank, default: 0] += 1
        }
        return dictionary.map { ($0.value.rawValue, $0.value.count) }
            .sorted { $0.count > $1.count || ($0.count == $1.count && $0.value > $1.value) }
    }

    func compare(to otherHand: Hand) -> ComparisonResult {
        let selfValues = valuesSortedByCount()
        let otherValues = otherHand.valuesSortedByCount()

        // Compare based on hand rank
        let selfHandRank = rank
        let otherHandRank = otherHand.rank
        if selfHandRank != otherHandRank {
            return selfHandRank.rawValue > otherHandRank.rawValue ? .win : .loss
        }

        // Compare based on highest rank in the hand
        let selfHighestRank = highestRank
        let otherHighestRank = otherHand.highestRank
        if selfHighestRank != otherHighestRank {
            return selfHighestRank.rawValue > otherHighestRank.rawValue ? .win : .loss
        }

        // Compare based on the values sorted by count
        for i in 0..<selfValues.count {
            let selfValue = selfValues[i]
            let otherValue = otherValues[i]

            if selfValue.count != otherValue.count {
                return selfValue.count > otherValue.count ? .win : .loss
            } else if selfValue.value != otherValue.value {
                return selfValue.value > otherValue.value ? .win : .loss
            }
        }

        // If all else fails, it's a tie
        return .tie
    }
}



var player1Wins = 0
var player2Wins = 0
var hand1: Hand
var hand5: Hand

let fileManager = FileManager.default
if let filePath = Bundle.main.path(forResource: "poker-hands", ofType: "txt"),
   fileManager.fileExists(atPath: filePath) {
   // File exists, continue with code
    if let url = Bundle.main.url(forResource: "poker-hands", withExtension: "txt"),
       let inputString = try? String(contentsOf: url) {
        
        let inputs = inputString.split(separator: "\n")
        for input in inputs {
            let cards = input.split(separator: " ").map { String($0) }
            print(cards)
            
            guard cards.count == 10 else {
                print("Invalid input: \(input)")
                break
            }
            
            let hand1Cards = Array(cards[0..<5])
            let hand2Cards = Array(cards[5..<10])
            print(hand1Cards)
            print(hand2Cards)
            
            hand1 = Hand(hand1Cards)
            
            hand5 = Hand(hand2Cards)
            
            switch compare(hand1, hand5) {
            case .player1Wins(let highestCard):
                print("Player 1 wins. Highest card: \(highestCard)")
                player1Wins += 1
            case .player2Wins(let highestCard):
                print("Player 2 wins. Highest card: \(highestCard)")
                player2Wins += 1
            case .tie(let highestCard):
                print("Tie. Highest card: \(highestCard)")
            }
        }

        
    } else {
        //print("Error: could not find poker-hands.txt in the main bundle.")
    }
    
    
    
} else {
   // File not found, handle error
    print("Error: could not find poker-hands.txt in the main bundle.")
}



print("Player 1: \(player1Wins) hands")
print("Player 2: \(player2Wins) hands")
