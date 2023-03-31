import Foundation

// Define card and hand structures
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
    let cards: [Card]

    init(_ cardStrings: [String]) {
        self.cards = cardStrings.compactMap { cardString -> Card? in
            guard let suitString = cardString.last,
                  let rankString = Optional(cardString.dropLast().description),
                  let suit = Suit(rawValue: String(suitString)),
                  let rank = Rank(rawValue: Int(rankString)!)
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

    func isFourOfAKind(counts: [Int: Int]) -> Bool {
        return counts.values.contains(4)
    }
}

enum Result {
    case player1Wins(highestCard: Rank)
    case player2Wins(highestCard: Rank)
    case tie(highestCard: Rank)
}

func compare(_ hand1: Hand, _ hand2: Hand) -> Result {
    let rank1 = hand1.rankValue
    let rank2 = hand2.rankValue

    if rank1 != rank2 {
        return rank1 > rank2 ? .player1Wins(highestCard: hand1.cards[0].rank) : .player2Wins(highestCard: hand2.cards[0].rank)
    } else {
        let values1 = hand1.cards.map { $0.rank.rawValue }.sorted(by: >)
        let values2 = hand2.cards.map { $0.rank.rawValue }.sorted(by: >)
        
        switch rank1 {
        case 10: // Royal flush
            return .tie(highestCard: Rank.ace)
        case 9, 5: // Straight flush or straight
            if values1[0] != values2[0] {
                return values1[0] > values2[0] ? .player1Wins(highestCard: hand1.cards[0].rank) : .player2Wins(highestCard: hand2.cards[0].rank)
            } else {
                return .tie(highestCard: hand1.cards[0].rank)
            }
        case 8, 4, 3, 2, 1: // Four of a kind, three of a kind, two pairs, pair, or high card
            let counts1 = Dictionary(grouping: values1, by: { $0 }).mapValues { $0.count }
            let counts2 = Dictionary(grouping: values2, by: { $0 }).mapValues { $0.count }
            let highestCount1 = counts1.values.max() ?? 0
            let highestCount2 = counts2.values.max() ?? 0
            let highestValue1 = counts1.filter { $0.value == highestCount1 }.keys.max() ?? 0
            let highestValue2 = counts2.filter { $0.value == highestCount2 }.keys.max() ?? 0

            if highestCount1 != highestCount2 {
                return highestCount1 > highestCount2 ? .player1Wins(highestCard: Rank(rawValue: highestValue1)!) : .player2Wins(highestCard: Rank(rawValue: highestValue2)!)
            } else if highestValue1 != highestValue2 {
                return highestValue1 > highestValue2 ? .player1Wins(highestCard: Rank(rawValue: highestValue1)!) : .player2Wins(highestCard: Rank(rawValue: highestValue2)!)
            } else {
                let otherValues1 = values1.filter { $0 != highestValue1 }
                let otherValues2 = values2.filter { $0 != highestValue2 }
                for i in 0..<otherValues1.count {
                    if otherValues1[i] != otherValues2[i] {
                        return otherValues1[i] > otherValues2[i] ? .player1Wins(highestCard: Rank(rawValue: otherValues1[i])!) : .player2Wins(highestCard: Rank(rawValue: otherValues2[i])!)
                    }
                }
                return .tie(highestCard: Rank.two)
            }
        default:
            print("done")
            return .tie(highestCard: Rank.two)
        }
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
