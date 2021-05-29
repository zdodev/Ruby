import UIKit

final class TourTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var inquiringLabel: UILabel!
    
    func configureCellLabel(_ tourViewModel: TourViewModel) {
        titleLabel.text = tourViewModel.title
        addressLabel.text = tourViewModel.address
        inquiringLabel.text = tourViewModel.inquiringNumber
    }
    
    func configureCellImage(data: Data) {
        DispatchQueue.main.async {
            self.mainImageView.image = UIImage(data: data)
        }
    }
    
    func setDefaultImage() {
        mainImageView.image = UIImage(systemName: "photo")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.image = nil
        titleLabel.text = nil
        addressLabel.text = nil
        inquiringLabel.text = nil
    }
}
