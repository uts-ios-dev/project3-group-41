import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
	
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet var answerButtons: Array<UIButton>?
    
    var quizIndex: Int = 0
	
	var quizs: [Quiz]?
	
    var totalScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizs = Quiz.generateQuiz()
        question.text = Quiz.question
        updateUI()
    }
    
    func updateUI() {
		navigationItem.title = "Quiz \(quizIndex + 1)"
		navigationItem.setRightBarButtonItems(nil, animated: true)
		
        let currentQuiz = quizs![quizIndex]
		let currentAnswers = currentQuiz.choices
		
		quizImage.image = currentQuiz.image
		
        for (i, answerButton) in answerButtons!.enumerated() {
            answerButton.setTitle("\(i + 1). \(currentAnswers[i])", for: .normal)
            answerButton.tintColor = UIColor.blue
            answerButton.isUserInteractionEnabled = true
            answerButton.addTarget(self, action: #selector(QuizViewController.answerClicked(_:)), for: .touchUpInside)
        }
	}
	
	// Move to the next quiz
	@IBAction func nextButtonClicked(_ sender: Any) {
        quizIndex += 1
        if quizIndex < quizs!.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultSegue", sender: nil)
        }
	}
	
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
        
        let rightButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(QuizViewController.nextButtonClicked(_:)))
        navigationItem.rightBarButtonItems = [rightButton]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultSegue" {
            let resultViewController = segue.destination as! ResultViewController
            resultViewController.result = totalScore
            resultViewController.maxScore = quizs!.count
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

