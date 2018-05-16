import Foundation
import UIKit
import AVFoundation

var a : [String: String] = [
    "a": "ascdas"
]

class PredictedObject {
    static let ciContext = CIContext()
    static let yolo = YOLO()
    static let synthesizer = AVSpeechSynthesizer()
    
    var resizedPixelBuffer: CVPixelBuffer?
    var utterance: AVSpeechUtterance? = nil
    var name: String? = nil
    var position: CGRect? = nil
    
    init() {
        setUpCoreImage()
    }
    
    convenience init(image: UIImage) {
        if let pixelBuffer = image.pixelBuffer(width: YOLO.inputWidth, height: YOLO.inputHeight) {
            self.init(pixelBuffer: pixelBuffer)
        } else {
            self.init()
        }
    }
    
    convenience init(pixelBuffer: CVPixelBuffer) {
        self.init()
        guard let resizedPixelBuffer = resizedPixelBuffer else {
            return
        }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(YOLO.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(YOLO.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform)
        PredictedObject.ciContext.render(scaledImage, to: resizedPixelBuffer)
        
        if let boundingBoxes = try? PredictedObject.yolo.predict(image: resizedPixelBuffer) {
            let boundingBox = selectMaxBox(boundingBoxes)
            
            name = labels[(boundingBox?.classIndex)!]
            utterance = AVSpeechUtterance(string: name!)
            utterance?.voice = AVSpeechSynthesisVoice(language: "en-AU")
            utterance?.rate = 0.2
            position = boundingBox?.rect
            
            print(name!)
            print(position!)
        }
    }
    
    func setUpCoreImage() {
        let status = CVPixelBufferCreate(nil, YOLO.inputWidth, YOLO.inputHeight,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &resizedPixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
        }
    }
    
    func selectMaxBox(_ boundingBoxes: [YOLO.Prediction]) -> YOLO.Prediction? {
        var result: YOLO.Prediction? = nil
        
        for boundingBox in boundingBoxes {
            if (result == nil || result!.rect.area() < boundingBox.rect.area()) {
                result = boundingBox
            }
        }
        
        return result
    }
    
    func speak() {
        PredictedObject.synthesizer.speak(utterance!)
    }
}

extension CGRect {
    func area() -> CGFloat {
        return width * height
    }
}
