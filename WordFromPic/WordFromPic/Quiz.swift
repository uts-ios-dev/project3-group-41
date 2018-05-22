import Foundation
import UIKit

class Quiz {
    static let defaultQuiz: Quiz = Quiz(choices: ["cup", "car", "bottle", "people"], image: UIImage(named: "sample")!)
    static let numberOfChoices: Int = 4
    static let maxNumberOfQuiz: Int = 4
    static let question: String = "What is this?"
    
    let choices: [String]
    let image: UIImage
    
    init(choices: [String], image: UIImage) {
        self.choices = choices
        self.image = image
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
            result.append(Quiz(choices: generateChoices(listOfNames, i), image: SavedObject.getImage(imageName: savedObjects[i].imageName)!))
        }
        
        return result
    }
    
    static func generateChoices(_ listOfNames: [String], _ rightAnwser: Int) -> [String] {
        let choices = Array(0..<listOfNames.count).shuffled()
        var result = [String]()
        
        result.append(listOfNames[rightAnwser])
        for i in 0..<numberOfChoices {
            if (choices[i] != rightAnwser) {
                result.append(listOfNames[choices[i]])
            }
            if result.count == numberOfChoices {
                break
            }
        }
        
        return result.shuffled()
    }
}
