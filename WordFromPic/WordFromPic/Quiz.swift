import Foundation
import UIKit

class Quiz {
    // default quiz in case there is no quiz in database.
    private static let defaultQuiz: Quiz = Quiz(choices: ["cup", "car", "bottle", "people"], image: UIImage(named: "sample")!, rightAnswer: 0)
    
    // number of choices in each quizs
    private static let numberOfChoices: Int = 4
    
    // maximum number of quizes in each run
    private static let maxNumberOfQuiz: Int = 4
    
    // question for all of the quiz
    private static let question: String = "What is this?"
    
    let choices: [String]   // Array of answers woth length equal to numberOfChoices
    let rightAnswer: Int    // The index of right answer in choices
    let image: UIImage      // The image of the object in question
    
    init(choices: [String], image: UIImage, rightAnswer: Int) {
        self.choices = choices
        self.image = image
        self.rightAnswer = rightAnswer
    }
    
    // View uses this function to generate the set of quiz for each run
    static func generateQuiz() -> [Quiz] {
        // try to load data from hard disk
        guard let savedObjects = SavedObject.loadData()?.shuffled() else {
            // if there is none, return default quiz
            return [defaultQuiz]
        }
        
        // List of possible answer
        var listOfNames: [String] = savedObjects.map{$0.name}
        
        // Append answer in default quiz in case there is not enough answer
        listOfNames.append(contentsOf: defaultQuiz.choices)
        
        // Make the list distinct
        listOfNames = Array(Set(listOfNames))
        
        let numberOfQuiz = min(maxNumberOfQuiz, savedObjects.count)
        
        var result = [Quiz]()
        for i in 0..<numberOfQuiz {
            let choices = generateChoices(listOfNames, savedObjects[i].name)
            
            var rightAnswer: Int = 0
            
            // Find position of the right answer in list of answer
            for (j, choice) in choices.enumerated() {
                if (choice == savedObjects[i].name) {
                    rightAnswer = j
                }
            }
            
            result.append(Quiz(choices: choices, image: SavedObject.getImage(imageName: savedObjects[i].imageName)!, rightAnswer: rightAnswer))
        }
        
        return result
    }
    
    private static func generateChoices(_ listOfNames: [String], _ rightAnwser: String) -> [String] {
        // Shuffle array of index to get random choices
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
