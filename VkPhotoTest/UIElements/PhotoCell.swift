import UIKit

class PhotoCell: UICollectionViewCell {
    
    var viewUIimage = UIImageView()
    
    func configurate(with image: UIImage){
        viewUIimage = UIImageView(frame: self.bounds)
        viewUIimage.image = image
        viewUIimage.clipsToBounds = true
        viewUIimage.contentMode = .scaleAspectFill
        viewUIimage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewUIimage)
    }
    
    override func prepareForReuse() {
        viewUIimage.image = nil
    }
    
}
