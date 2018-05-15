//
//  PreviewViewController.swift
//  WordFromPic
//
//  Created by Tyler Tran  on 15/5/18.
//  Copyright © 2018 Huy Lê. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
  var image: UIImage!
  
  @IBOutlet weak var photo: UIImageView!
  override func viewDidLoad() {
      super.viewDidLoad()
      photo.image = self.image
      // Do any additional setup after loading the view.
  }

  @IBAction func cancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func saveButton(_ sender: Any) {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    dismiss(animated: true, completion: nil)
  }
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
