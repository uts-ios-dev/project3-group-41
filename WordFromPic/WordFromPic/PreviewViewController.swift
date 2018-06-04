import UIKit

class PreviewViewController: UIViewController {
    var image: UIImage!
    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var photo: UIImageView!
    var predictedObject: PredictedObject? = nil
    var previousRunDateTime: Date = Date()
    @IBOutlet weak var soundButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Assign the photo captured into UIImageView of this screen
        photo.image = predictedObject?.image
        // Do any additional setup after loading the view.
        // Assign the label text as object name
        objectName.text = predictedObject?.name
      
        // Double tap recognizer to avoid double tap caused crash application
        let tap = UITapGestureRecognizer(target: soundAction(soundButton), action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
  
    // Set screen able to rotate
    @objc func canRotate() -> Void {}
  
    // Cancel action back to previous screen
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  
    // Save function able save captured image to photo library
    @IBAction func saveButton(_ sender: Any) {
    SavedObject.appendData((predictedObject?.name)!, (predictedObject?.image)!)
      UIImageWriteToSavedPhotosAlbum(photo.image!, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    // Sound button action - call object name when press
    @IBAction func soundAction(_ sender: UIButton) {
        let currentDateTime = Date()
        // Button click debouncing
        if (currentDateTime - 2 > previousRunDateTime) {
            predictedObject?.speak()
            previousRunDateTime = currentDateTime
        }
    }
  
    // Function for check double tap
    @objc func doubleTapped() {
      // Do nothing when double tap
    }
  
    // Hide the status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
