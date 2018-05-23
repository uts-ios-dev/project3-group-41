//
//  ViewController.swift
//  WorldExplorer1
//
//  Created by Nguyen Duc Thinh on 21/5/18.
//  Copyright © 2018 Nguyen Duc Thinh. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
	
    @IBOutlet weak var quizImage: UIImageView!
    
    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var answersStackView: UIStackView!
    @IBOutlet weak var firstAnswer: UIButton!
    @IBOutlet weak var secondAnswer: UIButton!
    @IBOutlet weak var thirdAnswer: UIButton!
    @IBOutlet weak var fourthAnswer: UIButton!
    
    @IBOutlet weak var quizProgress: UIProgressView!
    
    
    var quizIndex: Int = 0
	
	var quizs: [Quiz] = Quiz.generateQuiz()
	
//    var quizs: [Quiz] = [
//        Quiz(image: #imageLiteral(resourceName: "car"),
//             answers: [
//                Answer(text: "car"),
//                Answer(text: "ball"),
//                Answer(text: "tree"),
//                Answer(text: "house")],
//             correctAnswer: "car"),
//        Quiz(image: #imageLiteral(resourceName: "ball"),
//             answers: [
//                Answer(text: "rocket"),
//                Answer(text: "tree"),
//                Answer(text: "ball"),
//                Answer(text: "house")],
//             correctAnswer: "ball"),
//        Quiz(image: #imageLiteral(resourceName: "car"),
//             answers: [
//                Answer(text: "door"),
//                Answer(text: "ball"),
//                Answer(text: "tree"),
//                Answer(text: "car")],
//             correctAnswer: "car"),
//        Quiz(image: #imageLiteral(resourceName: "Tree"),
//             answers: [
//                Answer(text: "window"),
//                Answer(text: "ball"),
//                Answer(text: "tree"),
//                Answer(text: "house")],
//             correctAnswer: "tree"),
//        Quiz(image: #imageLiteral(resourceName: "House"),
//             answers: [
//                Answer(text: "table"),
//                Answer(text: "window"),
//                Answer(text: "house"),
//                Answer(text: "fridge")],
//             correctAnswer: "house"),
//        ]
	
    var totalScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
		
    }
    
    func updateUI() {
		navigationItem.title = "Quiz \(quizIndex + 1)"
		navigationItem.setRightBarButtonItems(nil, animated: true)
		
		let currentQuiz = quizs[quizIndex]
		let currentAnswers = currentQuiz.choices
		
		quizImage.image = currentQuiz.image
		
		firstAnswer.setTitle("A. \(currentAnswers[0])", for: .normal)
		firstAnswer.tintColor = UIColor.blue
		firstAnswer.isUserInteractionEnabled = true
		
		secondAnswer.setTitle("B. \(currentAnswers[1])", for: .normal)
		secondAnswer.tintColor = UIColor.blue
		secondAnswer.isUserInteractionEnabled = true
		
		thirdAnswer.setTitle("C. \(currentAnswers[2])", for: .normal)
		thirdAnswer.tintColor = UIColor.blue
		thirdAnswer.isUserInteractionEnabled = true
		
		fourthAnswer.setTitle("D. \(currentAnswers[3])", for: .normal)
		fourthAnswer.tintColor = UIColor.blue
		fourthAnswer.isUserInteractionEnabled = true
		
		let totalProgress = Float(quizIndex) / Float(quizs.count)
		quizProgress.setProgress(totalProgress, animated: true)
	}

    // Manage the quiz progress and proceed to the result screen if the quiz is done
	@objc func nextQuestion() {
		quizIndex += 1
		if quizIndex < quizs.count {
			updateUI()
		} else {
			performSegue(withIdentifier: "ResultSegue", sender: nil)
		}
	}
	
	// Move to the next quiz
	@IBAction func nextButtonPressed(_ sender: Any) {
		nextQuestion()
	}
	
    @IBAction func firstAnswerPressed(_ sender: UIButton) {
		checkAnswer(currentAnswer: quizs[quizIndex].choices[0], currentButton: firstAnswer)
    }
    @IBAction func secondAnswerPressed(_ sender: UIButton) {
		checkAnswer(currentAnswer: quizs[quizIndex].choices[1], currentButton: secondAnswer)
    }
    @IBAction func thirdAnswerPressed(_ sender: UIButton) {
		checkAnswer(currentAnswer: quizs[quizIndex].choices[2], currentButton: thirdAnswer)
    }
    @IBAction func fourthAnswerPressed(_ sender: UIButton) {
		checkAnswer(currentAnswer: quizs[quizIndex].choices[3], currentButton: fourthAnswer)
    }
    
    func checkAnswer(currentAnswer: String, currentButton: UIButton) {
		let correctAnswer:Int = quizs[quizIndex].rightAnswer
        if currentAnswer == quizs[quizIndex].choices[correctAnswer] {
            currentButton.tintColor = UIColor.green
            totalScore += 1
			
			let rightButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextQuestion))
			navigationItem.rightBarButtonItems = [rightButton]
			
			firstAnswer.isUserInteractionEnabled = false
			secondAnswer.isUserInteractionEnabled = false
			thirdAnswer.isUserInteractionEnabled = false
			fourthAnswer.isUserInteractionEnabled = false
        } else {
            currentButton.tintColor = UIColor.red
        }
    }
    
	// Manage the segue to Results View Controller and passed the total score data to it for displaying final result
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultSegue" {
            let resultViewController = segue.destination as! ResultViewController
            resultViewController.result = totalScore
			resultViewController.maxScore = quizs.count
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

