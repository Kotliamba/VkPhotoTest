import UIKit

class TableCell: UITableViewCell {
    
    var label = UILabel()
    var uiImageView = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurate(name: String, image: UIImage?){
        self.backgroundColor = .white
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width/2, height: self.bounds.height))
        uiImageView = UIImageView(frame: CGRect(x: self.bounds.width/2, y: 0, width: self.bounds.width/2, height: self.bounds.height))
        uiImageView.image = UIImage(named: "placeholder")!
        if image != nil {
            uiImageView.image = image
        }
        uiImageView.contentMode = .scaleAspectFit
        contentView.addSubview(uiImageView)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.textColor = .black
        label.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
