import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultNavigationBar: UINavigationBar!
    
    @IBOutlet weak var congratLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var result: Int = 0
    var maxScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        let retakeButton = UIBarButtonItem(title: "Retake", style: .plain, target: self, action: #selector(ResultViewController.unwindToQuizVC(_:)))
        navigationItem.leftBarButtonItem = retakeButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ResultViewController.unwindToMainVC(_:)))
        navigationItem.rightBarButtonItem = doneButton

        navigationItem.title = "Result"
        
        resultNavigationBar.items = [navigationItem]
        
        if result > 0 {
            congratLabel.text = "Congratulations !!!"
            resultLabel.text = "You got \(result) out of \(maxScore) scores!"
        } else {
            congratLabel.text = "You don't have any score :("
            resultLabel.text = "Try harder next time"
        }
    }
    
    @IBAction func unwindToQuizVC(_ sender: Any) {
        performSegue(withIdentifier: "unwindToQuizVC", sender: self)
    }
    
    @IBAction func unwindToMainVC(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToQuizVC" {
            let quizViewController = segue.destination as! QuizViewController
            quizViewController.viewDidLoad()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
