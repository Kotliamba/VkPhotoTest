import UIKit

struct Converter {
    static func stringToImage (string: String) -> UIImage? {
        let imageData = Data(base64Encoded: string)
        guard let image = UIImage(data: imageData!) else {return nil}
        return image
    }
}
