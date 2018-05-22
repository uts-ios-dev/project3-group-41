import Foundation
import UIKit

struct ImageObject {
    let name: String
    let image: UIImage

    static func getSavedObject(_ data: ImageObject) -> SavedObject {
        return SavedObject(imageName: SavedObject.saveImage(image: data.image), name: data.name)
    }
}

struct SavedObject: Codable {
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    let imageName: String
    let name: String

    static func loadData() -> [SavedObject]?  {
        guard let codedData = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<SavedObject>.self, from: codedData)
    }
    
    static func appendData(_ data: SavedObject) {
        var savedObjects: [SavedObject]
        if SavedObject.loadData() != nil {
            savedObjects = SavedObject.loadData()!
        } else {
            savedObjects = [SavedObject]()
        }
        savedObjects.append(data)
        
        SavedObject.saveData(savedObjects)
    }
    
    static func saveData(_ data: [SavedObject]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedData = try? propertyListEncoder.encode(data)
        try? codedData?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    // https://stackoverflow.com/questions/44911013/save-uiimage-array-to-disk
    static func saveImage(image: UIImage) -> String {
        let imageData = NSData(data: UIImagePNGRepresentation(image)!)
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let docs = paths[0] as NSString
        let uuid = NSUUID().uuidString + ".png"
        let fullPath = docs.appendingPathComponent(uuid)
        _ = imageData.write(toFile: fullPath, atomically: true)
        
        return uuid
    }
    
    static func getImage(imageName: String) -> UIImage? {
        if let imagePath = getFilePath(fileName: imageName) {
            return UIImage(contentsOfFile: imagePath)!
        }
        
        return nil
    }
    
    // https://stackoverflow.com/questions/44911013/save-uiimage-array-to-disk
    static func getFilePath(fileName: String) -> String? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        var filePath: String?
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if paths.count > 0 {
            let dirPath = paths[0] as NSString
            filePath = dirPath.appendingPathComponent(fileName)
        } else {
            filePath = nil
        }
        
        return filePath
    }
}
