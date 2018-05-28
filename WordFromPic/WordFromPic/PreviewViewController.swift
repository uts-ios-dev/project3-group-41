import UIKit

class PreviewViewController: UIViewController {
    var image: UIImage!
    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var photo: UIImageView!
    var predictedObject: PredictedObject? = nil
  @IBOutlet weak var soundButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = predictedObject?.image
        // Do any additional setup after loading the view.
        objectName.text = predictedObject?.name
        let tap = UITapGestureRecognizer(target: soundAction(soundButton), action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
  
    @objc func canRotate() -> Void {}

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButton(_ sender: Any) {
    SavedObject.appendData((predictedObject?.name)!, (predictedObject?.image)!)
      UIImageWriteToSavedPhotosAlbum(photo.image!, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func soundAction(_ sender: UIButton) {
        predictedObject?.speak()
    }
  
    @objc func doubleTapped() {
      // do something here
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
