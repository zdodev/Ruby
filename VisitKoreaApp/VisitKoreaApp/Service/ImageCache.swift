import Foundation

struct ImageCache {
    private let fileManager = FileManager.default
    private let memoryCache = NSCache<NSString, NSData>()
    private let tourImageService = TourImageService(sessionManager: URLSession.shared)
    private let path: URL
    
    init() {
        path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    func fetchImage(urlString: String, cell: TourTableViewCell) {
        guard let url = URL(string: urlString) else {
            return
        }
        let fileName = url.lastPathComponent
        
        
        if isMemoryCached(fileName) {
            guard let cachedData = memoryCache.object(forKey: fileName as NSString) else {
                return
            }
            cell.configureCellImage(data: cachedData as Data)
        } else if isDiskCached(fileName) {
            guard let cachedData = fetchDiskCache(fileName) else {
                return
            }
            cell.configureCellImage(data: cachedData)
        } else {
            downloadImage(url, cell)
        }
    }
    
    private func createMemoryCache(_ fileName: String, _ data: Data) {
        memoryCache.setObject(data as NSData, forKey: fileName as NSString)
    }
    
    private func createDiskCache(_ fileName: String, _ data: Data) {
        let filePath = path.appendingPathComponent(fileName)
        fileManager.createFile(atPath: filePath.path, contents: data)
    }
    
    private func fetchDiskCache(_ fileName: String) -> Data? {
        let filePathURL = path.appendingPathComponent(fileName)
        do {
            let cachedData = try Data(contentsOf: filePathURL)
            createMemoryCache(fileName, cachedData)
            return cachedData
        } catch {
            return nil
        }
    }
    
    private func downloadImage(_ url: URL, _ cell: TourTableViewCell) {
        tourImageService.downloadImage(url: url) { result in
            switch result {
            case .success(let data):
                let fileName = url.lastPathComponent
                cell.configureCellImage(data: data)
                createDiskCache(fileName, data)
                createMemoryCache(fileName, data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func isMemoryCached(_ fileName: String) -> Bool {
        memoryCache.object(forKey: fileName as NSString) != nil
    }
    
    private func isDiskCached(_ fileName: String) -> Bool {
        let filePath = path.appendingPathComponent(fileName)
        return fileManager.fileExists(atPath: filePath.path)
    }
}
