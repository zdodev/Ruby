import UIKit
@testable import VisitKoreaApp

final class TourImageServiceSessionManagerStub: SessionManagerProtocol {
    var url: URL?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        
        let stubData = makeStubData()
        
        completionHandler(stubData, nil, nil)
        
        return URLSession.shared.dataTask(with: URLRequest(url: url))
    }
    
    private func makeStubData() -> Data? {
        let image = UIImage(systemName: "photo")
        return image?.pngData()
    }
}
