import Foundation

/// CFR - http://modelai.gettysburg.edu/2013/cfr/cfr.pdf
/// https://www.youtube.com/watch?v=7m4bnmSkjow
/// IDEA - take this when your'e done, and add UI component where you "animate" / "render" games and display graphs
/// Animate graph of strategy like geohot

enum Action: Int, CaseIterable {
    case rock = 0
    case paper
    case scissors
    
    static func random() -> Action {
        return Action(rawValue: Int.random(in: 0..<allCases.count))!
    }
}

let oppStrategy: [Double] = [0.4, 0.3, 0.3]
var regretSum: [Double] = [0, 0, 0]
var strategySum: [Double] = [0, 0, 0]

func getStrategy() -> [Double] {
    var noramlizingSum: Double = 0
    for i in 0..<Action.allCases.count {
        strategySum[i] = regretSum[i] > 0 ? regretSum[i] : 0
        noramlizingSum += strategySum[i]
    }
    for i in 0..<Action.allCases.count {
        if noramlizingSum > 0 {
            strategySum[i] /= noramlizingSum
        } else {
            strategySum[i] = 1.0 / Double(Action.allCases.count)
        }
        strategySum[i] += strategySum[i]
    }
    return strategySum
}

func getAction(for strategy: [Double]) -> Action {
    let r = Double.random(in: 0...1)
    var i = 0
    var cumulativeProbability: Double = 0
    while i < Action.allCases.count - 1 {
        cumulativeProbability += strategy[i]
        if r < cumulativeProbability {
            break
        }
        i += 1
    }
    return Action(rawValue: i)!
}

func train(iterations: Int) {
    var actionUtility: [Double] = [0, 0, 0]
    for _ in 0..<iterations {
        let strategy = getStrategy()
        let myAction = getAction(for: strategy)
        let oppAction = getAction(for: oppStrategy)
        
        actionUtility[oppAction.rawValue] = 0
        actionUtility[oppAction.rawValue == Action.allCases.count - 1 ? 0 : oppAction.rawValue + 1] = 1
        actionUtility[oppAction.rawValue == 0 ? Action.allCases.count - 1 : oppAction.rawValue - 1] = -1
        
        for i in 0..<Action.allCases.count {
            regretSum[i] += actionUtility[i] - actionUtility[myAction.rawValue]
        }
    }
}

func getAverageStragegy() -> [Double] {
    var avgStrategy: [Double] = [0, 0, 0]
    var normalizingSum: Double = 0
    for i in 0..<Action.allCases.count {
        normalizingSum += strategySum[i]
    }
    for i in 0..<Action.allCases.count {
        if normalizingSum > 0 {
            avgStrategy[i] = strategySum[i] / normalizingSum
        } else {
            avgStrategy[i] = 1.0 / Double(Action.allCases.count)
        }
    }
    return avgStrategy
}

func trainAndLogAvgStategy() {
    train(iterations: 1000)
    print(getAverageStragegy())
}

trainAndLogAvgStategy()

class RPSTrainer {
    ///
}
