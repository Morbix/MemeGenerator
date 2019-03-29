import UIKit

final class Placeholder: UIImage {
    convenience override init() {
        self.init(imageLiteralResourceName: "placeholder-meme")
    }
}
