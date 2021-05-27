import UIKit

final class TourInformationViewController: UIViewController {
    @IBOutlet weak var tourListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tourListTableView.dataSource = self
    }
}

extension TourInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tourListTableView.dequeueReusableCell(withIdentifier: "TourTableViewCell", for: indexPath) as! TourTableViewCell
        cell.mainImage.backgroundColor = .systemBlue
        return cell
    }
}
