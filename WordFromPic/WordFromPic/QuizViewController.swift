import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var quizNavigationBar: UINavigationBar!
    
    @IBOutlet weak var nextButton: UIButton!
	
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet var answerButtons: Array<UIButton>?
    
    var quizIndex: Int = 0
	
    var totalScore: Int = 0
    
	var quizs: [Quiz]?
    var answerCharacters: [String] = ["A", "B", "C", "D"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizs = Quiz.generateQuiz()
        question.text = Quiz.question
        updateUI()
    }
    
    func updateUI() {
        navigationItem.title = "Quiz \(quizIndex + 1)"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(QuizViewController.cancelButtonClicked(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.setRightBarButtonItems(nil, animated: true)
        
        quizNavigationBar.items = [navigationItem]

        let currentQuiz = quizs![quizIndex]
		let currentAnswers = currentQuiz.choices
		
		quizImage.image = currentQuiz.image
		
        //Set up the answers for the current quiz
        for (i, answerButton) in answerButtons!.enumerated() {
            answerButton.setTitle("\(answerCharacters[i]). \(currentAnswers[i].capitalizingFirstLetter())", for: .normal)
            answerButton.tintColor = UIColor.blue
            answerButton.isUserInteractionEnabled = true
            answerButton.addTarget(self, action: #selector(QuizViewController.answerClicked(_:)), for: .touchUpInside)
        }
	}
	
    //Move back to the main screen
    @IBAction func cancelButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }
    
	//Move to the next quiz
	@IBAction func nextButtonClicked(_ sender: Any) {
        quizIndex += 1
        if quizIndex < quizs!.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultSegue", sender: self)
        }
        
	}
	
    //Check the chosen answer. If the answer is correct, it will turn green and the user will get 1 point otherwise it will turn red the user will get nothing.
    @IBAction func answerClicked(_ sender: UIButton?) {
        let currentQuiz = quizs![quizIndex]
        for (i, answerButton) in answerButtons!.enumerated() {
            answerButton.isUserInteractionEnabled = false
            if (sender == answerButton) {
                if (i == currentQuiz.rightAnswer) {
                    totalScore += 1
                } else {
                    answerButton.tintColor = UIColor.red
                }
            }
            
            if (i == currentQuiz.rightAnswer) {
                answerButton.tintColor = UIColor.green
            }
        }
        
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(QuizViewController.nextButtonClicked(_:)))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    //Pass the player's score and total score to the result view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultSegue" {
            let resultViewController = segue.destination as! ResultViewController
            resultViewController.result = totalScore
            resultViewController.maxScore = quizs!.count
            quizIndex = 0
            totalScore = 0
        }
    }

    @IBAction func unwindToQuizVC(segue: UIStoryboardSegue) { }
    
    //Hide the status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

/*https://www.hackingwithswift.com/example-code/strings/how-to-capitalize-the-first-letter-of-a-string
 This function return a string with the first letter capitalized*/
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
