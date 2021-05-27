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
    
    func configureCellImage() {
        
    }
}
