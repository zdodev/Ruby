import Foundation
@testable import VisitKoreaApp

final class TourAPISessionManagerStub: SessionManagerProtocol {
    var url: URL?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        
        let stubData = makeStubData()
        
        completionHandler(stubData, nil, nil)
        
        return URLSession.shared.dataTask(with: URLRequest(url: url))
    }
    
    private func makeStubData() -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "TourInformationSample", withExtension: "json") else {
            return nil
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }
}
