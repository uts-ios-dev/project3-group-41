import Foundation
import UIKit

class Quiz {
    static let defaultQuiz: Quiz = Quiz(choices: ["cup", "car", "bottle", "people"], image: UIImage(named: "sample")!, rightAnswer: 0)
    static let numberOfChoices: Int = 4
    static let maxNumberOfQuiz: Int = 4
    static let question: String = "What is this?"
    
    let choices: [String]
    let rightAnswer: Int
    let image: UIImage
    
    init(choices: [String], image: UIImage, rightAnswer: Int) {
        self.choices = choices
        self.image = image
        self.rightAnswer = rightAnswer
    }
    
    static func generateQuiz() -> [Quiz] {
        guard let savedObjects = SavedObject.loadData()?.shuffled() else {
            return [defaultQuiz]
        }
        
        var listOfNames: [String] = savedObjects.map{$0.name}
        listOfNames.append(contentsOf: defaultQuiz.choices)
        listOfNames = Array(Set(listOfNames))
        
        let numberOfQuiz = min(maxNumberOfQuiz, savedObjects.count)
        
        var result = [Quiz]()
        for i in 0..<numberOfQuiz {
            let choices = generateChoices(listOfNames, savedObjects[i].name)
            
            var rightAnswer: Int = 0
            for (j, choice) in choices.enumerated() {
                if (choice == savedObjects[i].name) {
                    rightAnswer = j
                }
            }
            
            result.append(Quiz(choices: choices, image: SavedObject.getImage(imageName: savedObjects[i].imageName)!, rightAnswer: rightAnswer))
        }
        
        return result
    }
    
    static func generateChoices(_ listOfNames: [String], _ rightAnwser: String) -> [String] {
        let choices = Array(0..<listOfNames.count).shuffled()
        var result = [String]()
        
        result.append(rightAnwser)
        for i in 0..<numberOfChoices {
            if (listOfNames[choices[i]] != rightAnwser) {
                result.append(listOfNames[choices[i]])
            }
            if result.count == numberOfChoices {
                break
            }
        }
        
        return result.shuffled()
    }
}
