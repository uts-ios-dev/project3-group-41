import UIKit

class PreviewViewController: UIViewController {
    var image: UIImage!
    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var photo: UIImageView!
    var predictedObject: PredictedObject? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = predictedObject?.image
        // Do any additional setup after loading the view.
        objectName.text = predictedObject?.name
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

    @IBAction func soundAction(_ sender: UIButton) {
        predictedObject?.speak()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
