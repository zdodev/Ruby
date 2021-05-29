import Foundation

struct ImageCache {
    private let fileManager = FileManager.default
    private let imageMemoryCache = NSCache<NSString, NSData>()
    private let tourImageService = TourImageService(sessionManager: URLSession.shared)

    func fetchImage(urlString: String, cell: TourTableViewCell) {
        downloadImage(urlString, cell)
    }
    
    private func downloadImage(_ urlString: String, _ cell: TourTableViewCell) {
        tourImageService.downloadImage(url: urlString) { result in
            switch result {
            case .success(let data):
                cell.configureCellImage(data: data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
