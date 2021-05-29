import Foundation

struct ImageCache {
    private let fileManager = FileManager.default
    private let imageMemoryCache = NSCache<NSString, NSData>()
    private let tourImageService = TourImageService(sessionManager: URLSession.shared)
    private let path: URL
    
    init() {
        path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    func fetchImage(urlString: String, cell: TourTableViewCell) {
        guard let fileName = separateLastPathComponent(urlString) else {
            return
        }
        
        if isDiskCached(fileName) {
            guard let cachedData = fetchDiskCache(fileName) else {
                return
            }
            cell.configureCellImage(data: cachedData)
        } else {
            downloadImage(urlString, cell)
        }
    }
    
    private func isDiskCached(_ fileName: String) -> Bool {
        let filePath = path.appendingPathComponent(fileName)
        return fileManager.fileExists(atPath: filePath.path)
    }
    
    private func fetchDiskCache(_ fileName: String) -> Data? {
        let filePathURL = path.appendingPathComponent(fileName)
        do {
            let cachedData = try Data(contentsOf: filePathURL)
            return cachedData
        } catch {
            return nil
        }
    }

    private func createDiskCache(_ urlString: String, _ data: Data) {
        guard let fileName = separateLastPathComponent(urlString) else {
            return
        }
        let filePath = path.appendingPathComponent(fileName)
        fileManager.createFile(atPath: filePath.path, contents: data)
    }
    
    private func downloadImage(_ urlString: String, _ cell: TourTableViewCell) {
        tourImageService.downloadImage(url: urlString) { result in
            switch result {
            case .success(let data):
                cell.configureCellImage(data: data)
                createDiskCache(urlString, data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func separateLastPathComponent(_ urlString: String) -> String? {
        URL(string: urlString)?.lastPathComponent
    }
}
