//
//  ResultViewController.swift
//  WorldExplorer1
//
//  Created by Nguyen Duc Thinh on 21/5/18.
//  Copyright © 2018 Nguyen Duc Thinh. All rights reserved.
//

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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
