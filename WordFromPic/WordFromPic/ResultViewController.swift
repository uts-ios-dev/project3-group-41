import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var congratLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var result: Int = 0
    var maxScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        congratLabel.text = "Congratulations !!!"
        resultLabel.text = "You got \(result) out of \(maxScore) scores!"
    }
    
    @IBAction func unwindToMainVC(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }
    
    @IBAction func unwindToQuizVC(_ sender: Any) {
        performSegue(withIdentifier: "unwindToQuizVC", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
