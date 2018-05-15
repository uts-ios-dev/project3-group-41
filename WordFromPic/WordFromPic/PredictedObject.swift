import Foundation
import UIKit

class PredictedObject {
    var resizedPixelBuffer: CVPixelBuffer?
    static let ciContext = CIContext()
    static let yolo = YOLO()
    var name: String? = nil
    var position: CGRect? = nil
    
    init() {
        setUpCoreImage()
    }
    
    func setUpCoreImage() {
        let status = CVPixelBufferCreate(nil, YOLO.inputWidth, YOLO.inputHeight,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &resizedPixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
        }
    }
    
    func predict(image: UIImage) {
        if let pixelBuffer = image.pixelBuffer(width: YOLO.inputWidth, height: YOLO.inputHeight) {
            predict(pixelBuffer: pixelBuffer)
        }
    }
    
    func predict(pixelBuffer: CVPixelBuffer) {
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
            position = boundingBox?.rect
            
            print(name!)
            print(position!)
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
}

extension CGRect {
    func area() -> CGFloat {
        return width * height
    }
}
