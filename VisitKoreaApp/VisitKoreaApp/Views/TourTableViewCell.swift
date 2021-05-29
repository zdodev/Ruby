import UIKit

final class TourTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var inquiringLabel: UILabel!
    
    func configureCell(_ tourViewModel: TourViewModel) {
        titleLabel.text = tourViewModel.title
        addressLabel.text = tourViewModel.address
        inquiringLabel.text = tourViewModel.inquiringNumber
    }
    
    func configureCellImage(data: Data) {
        DispatchQueue.main.async {
            self.mainImage.image = UIImage(data: data)
        }
    }
    
    func setDefaultImage() {
        mainImage.image = UIImage(systemName: "photo")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImage.image = nil
        titleLabel.text = nil
        addressLabel.text = nil
        inquiringLabel.text = nil
    }
}
