import UIKit

final class TourInformationViewController: UIViewController {
    @IBOutlet weak var tourListTableView: UITableView!
    private let tourAPIService = TourAPIService(sessionManager: URLSession.shared)
    private var tourViewModels = [TourViewModel]()
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tourListTableView.dataSource = self
        queryTourInformation()
        queryTourInformation()
        queryTourInformation()
    }
    
    func queryTourInformation() {
        tourAPIService.search(pageNumber: page) { [weak self] result in
            switch result {
            case .success(let tourInformation):
                guard let tourViewModel = self?.makeTourViewModel(tourInformation) else {
                    return
                }
                self?.tourViewModels.append(tourViewModel)
                DispatchQueue.main.async {
                    self?.tourListTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func makeTourViewModel(_ tourInformation: TourInformation) -> TourViewModel {
        let title = tourInformation.response.body.items.item.title
        var address = tourInformation.response.body.items.item.baseAddress
        if let detailAddress = tourInformation.response.body.items.item.detailAddress {
            address += detailAddress
        }
        let inquiringNumber = tourInformation.response.body.items.item.inquiringNumber
        
        return TourViewModel(title: title, address: address, inquiringNumber: inquiringNumber)
    }
}

extension TourInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tourViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TourTableViewCell", for: indexPath) as? TourTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(tourViewModels[indexPath.row])
        return cell
    }
}
