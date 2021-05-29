import UIKit

struct TourImageService {
    private let sessionManager: SessionManagerProtocol
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    func downloadImage(url: URL, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        sessionManager.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let receivedData = data else {
                completionHandler(.failure(.dataReceiveError))
                return
            }

            completionHandler(.success(receivedData))
        }.resume()
    }
}
