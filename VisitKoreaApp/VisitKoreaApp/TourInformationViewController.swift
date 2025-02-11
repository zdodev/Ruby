import UIKit

final class TourInformationViewController: UIViewController {
    @IBOutlet weak var tourListTableView: UITableView!
    private let tourAPIService = TourAPIService(sessionManager: URLSession.shared)
    private let imageCache = ImageCache()
    private var tourViewModels = [TourViewModel]()
    private var isPaging = false
    private var pageNumber = 0
    private var totalPage = 0
    private var remainPage = 2
    
    private func fetchTourInformation<T: Decodable>(_ page: Int, type: T.Type) {
        tourAPIService.search(pageNumber: page, type: TourInformation.self) { [weak self] result in
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
    
    private func fetchTourInformationSingleItem<T: Decodable>(_ page: Int, type: T.Type) {
        tourAPIService.search(pageNumber: page, type: TourInformationSingleItem.self) { [weak self] result in
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
        let hasOneRaminePage = remainPage == 1
        if hasOneRaminePage {
            fetchTourInformationSingleItem(pageNumber, type: TourInformationSingleItem.self)
        } else {
            fetchTourInformation(pageNumber, type: TourInformation.self)
        }
    }
    
    private func makeTourViewModel(_ tourInformation: TourInformation) -> [TourViewModel] {
        tourInformation.response.body.items.item.map { item in
            TourViewModel(title: item.title,
                          address: item.baseAddress + (item.detailAddress ?? ""),
                          inquiringNumber: item.inquiringNumber,
                          imageURLString: item.imageURLAddress ?? "")
        }
    }
    
    private func makeTourSingleViewModel(_ tourInformationSingleItem: TourInformationSingleItem) -> TourViewModel {
        TourViewModel(title: tourInformationSingleItem.response.body.items.item.title,
                      address: tourInformationSingleItem.response.body.items.item.baseAddress +
                        (tourInformationSingleItem.response.body.items.item.detailAddress ?? ""),
                      inquiringNumber: tourInformationSingleItem.response.body.items.item.inquiringNumber,
                      imageURLString: tourInformationSingleItem.response.body.items.item.imageURLAddress ?? "")
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
        cell.configureCellLabel(tourViewModels[indexPath.row])
        cell.setDefaultImage()
        imageCache.fetchImage(urlString: tourViewModels[indexPath.row].imageURLString, cell: cell)
        
        return cell
    }
}

extension TourInformationViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewOffsetY = scrollView.contentOffset.y
        let scrollViewtHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        let contentHeightGreaterThanScrollSize = scrollViewOffsetY > (scrollViewtHeight - height)
        
        if contentHeightGreaterThanScrollSize {
            let hasNextPage = remainPage > 0
            
            if isPaging == false && hasNextPage {
                nextPaging()
            }
            
            if !hasNextPage {
                alertLastPage()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func alertLastPage() {
        let alert = UIAlertController(title: "마지막 페이지입니다.", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
