import Foundation
import UIKit
import AVFoundation

let wordMap: [String: String] = [
    "notebook, notebook computer": "laptop",
    "iPod": "smartphone",
    "mouse, computer mouse": "mouse",
    "laptop, laptop computer": "laptop",
    "ballpoint, ballpoint pen, ballpen, Biro": "pen",
    "cellular telephone, cellular phone, cellphone, cell, mobile": "mobile",
    "letter opener, paper knife, paperknife": "paperknife",
    "vacuum, vacuum cleaner": "vacuum cleaner",
    "refridgerator, icebox": "refridgerator",
    "ashcan, trash can, garbage can, wastebin, ash bin, ash-bin, ashbin, dustbin, trash barrel, trash bin": "bin",
    "wallet, billfold, notecase, pocketbook": "wallet"
]

// Model to predict the name of the object from image
class PredictedObject {
    static let ciContext = CIContext()
    static let inceptionv3model = Inceptionv3()
    static let inputWidth = 299
    static let inputHeight = 299
    static let synthesizer = AVSpeechSynthesizer()
    
    var resizedPixelBuffer: CVPixelBuffer?
    var utterance: AVSpeechUtterance? = nil
    var image: UIImage? = nil
    var name: String? = nil

    init(image: UIImage) {
        self.image = image
        
        // Convert image into CVPixelBuffer
        setUpCoreImage()
        if let pixelBuffer = image.pixelBuffer(width: PredictedObject.inputWidth, height: PredictedObject.inputHeight) {
            self.predict(pixelBuffer: pixelBuffer)
        }
    }
    
    func predict(pixelBuffer: CVPixelBuffer) {
        // Check the resizedPixelBuffer is set up
        guard let resizedPixelBuffer = resizedPixelBuffer else {
            return
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // Prepare tranformer for image scaling
        let sx = CGFloat(PredictedObject.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(PredictedObject.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        
        // Scale image to predefined model input size
        let scaledImage = ciImage.transformed(by: scaleTransform)
        PredictedObject.ciContext.render(scaledImage, to: resizedPixelBuffer)
        
        do {
            let prediction = try PredictedObject.inceptionv3model.prediction(image: resizedPixelBuffer)
            name = prediction.classLabel
            if (wordMap[name!] != nil) {
                name = wordMap[name!]?.capitalizingFirstLetter()
            } else {
                name = name?.split{$0 == ","}.map(String.init)[0].capitalizingFirstLetter()
            }
        } catch let error {
            fatalError("Unexpected error ocurred when predicting: \(error.localizedDescription).")
        }
        
        // Set up speech for object name
        utterance = AVSpeechUtterance(string: name!)
        utterance?.voice = AVSpeechSynthesisVoice(language: "en-AU")
        utterance?.rate = 0.5
    }
    
    // Set up resizedPixelBuffer for image predicttion
    func setUpCoreImage() {
        let status = CVPixelBufferCreate(nil, PredictedObject.inputWidth, PredictedObject.inputHeight,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &resizedPixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
        }
    }
    
    func speak() {
        PredictedObject.synthesizer.speak(utterance!)
    }
}



