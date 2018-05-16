import Foundation
import UIKit
import AVFoundation

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
        setUpCoreImage()
        if let pixelBuffer = image.pixelBuffer(width: PredictedObject.inputWidth, height: PredictedObject.inputHeight) {
            self.predict(pixelBuffer: pixelBuffer)
        }
        self.image = image
    }
    
    func predict(pixelBuffer: CVPixelBuffer) {
        guard let resizedPixelBuffer = resizedPixelBuffer else {
            return
        }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(PredictedObject.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(PredictedObject.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform)
        PredictedObject.ciContext.render(scaledImage, to: resizedPixelBuffer)
        
        do {
            let prediction = try PredictedObject.inceptionv3model.prediction(image: resizedPixelBuffer)
            name = prediction.classLabel
            utterance = AVSpeechUtterance(string: name!)
            utterance?.voice = AVSpeechSynthesisVoice(language: "en-AU")
            utterance?.rate = 0.2
            
            print(name!)
        } catch let error {
            fatalError("Unexpected error ocurred when predicting: \(error.localizedDescription).")
        }
    }
    
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
