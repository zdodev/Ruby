import UIKit

final class TourInformationViewController: UIViewController {
    @IBOutlet weak var tourListTableView: UITableView!
    private let tourAPIService = TourAPIService(sessionManager: URLSession.shared)
    private let tourImageService = TourImageService(sessionManager: URLSession.shared)
    private var tourViewModels = [TourViewModel]()
    private var isPaging = false
    private var pageNumber = 0
    private var totalPage = 0
    private var remainPage = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func queryTourInformation(_ page: Int) {
        tourAPIService.search(pageNumber: page) { [weak self] result in
            switch result {
            case .success(let tourInformation):
                let totalPage = tourInformation.response.body.totalCount
                let currentPage = tourInformation.response.body.numberOfRows * tourInformation.response.body.pageNumber
                self?.totalPage = totalPage
                self?.remainPage = totalPage - currentPage
                guard let tourViewModel = self?.makeTourViewModel(tourInformation) else {
                    return
                }
                self?.tourViewModels.append(contentsOf: tourViewModel)
                DispatchQueue.main.async {
                    self?.tourListTableView.reloadData()
                    self?.isPaging = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func queryTourInformationSingleItem(_ page: Int) {
        tourAPIService.searchSingleItem(pageNumber: page) { [weak self] result in
            switch result {
            case .success(let tourInformationSingleItem):
                let totalPage = tourInformationSingleItem.response.body.totalCount
                let currentPage = tourInformationSingleItem.response.body.numberOfRows * tourInformationSingleItem.response.body.pageNumber
                self?.totalPage = totalPage
                self?.remainPage = totalPage - currentPage
                self?.totalPage = tourInformationSingleItem.response.body.totalCount
                guard let tourViewModel = self?.makeTourSingleViewModel(tourInformationSingleItem) else {
                    return
                }
                self?.tourViewModels.append(tourViewModel)
                DispatchQueue.main.async {
                    self?.tourListTableView.reloadData()
                    self?.isPaging = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func nextPaging() {
        pageNumber += 1
        isPaging = true
        if remainPage == 1 {
            queryTourInformationSingleItem(pageNumber)
        } else {
            queryTourInformation(pageNumber)
        }
    }
    
    private func makeTourViewModel(_ tourInformation: TourInformation) -> [TourViewModel] {
        tourInformation.response.body.items.item.map { item in
            TourViewModel(title: item.title,
                          address: item.baseAddress + (item.detailAddress ?? ""),
                          inquiringNumber: item.inquiringNumber,
                          imageURL: item.imageURLAddress ?? "")
        }
    }
    
    private func makeTourSingleViewModel(_ tourInformationSingleItem: TourInformationSingleItem) -> TourViewModel {
        TourViewModel(title: tourInformationSingleItem.response.body.items.item.title,
                      address: tourInformationSingleItem.response.body.items.item.baseAddress +
                        (tourInformationSingleItem.response.body.items.item.detailAddress ?? ""),
                      inquiringNumber: tourInformationSingleItem.response.body.items.item.inquiringNumber,
                      imageURL: tourInformationSingleItem.response.body.items.item.imageURLAddress ?? "")
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
        tourImageService.search(url: tourViewModels[indexPath.row].imageURL) { result in
            switch result {
            case .success(let data):
                cell.configureCellImage(data: data)
            case .failure(let error):
                print(error)
            }
        }
        cell.configureCellImage(data: Data())
        return cell
    }
}

extension TourInformationViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if isPaging == false && hasNextPage() {
                nextPaging()
            }
            
            if !hasNextPage() {
                let alert = UIAlertController(title: "마지막 페이지입니다.", message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(alertAction)
                present(alert, animated: true)
            }
        }
    }
    
    private func hasNextPage() -> Bool {
        remainPage > 0
    }
}
