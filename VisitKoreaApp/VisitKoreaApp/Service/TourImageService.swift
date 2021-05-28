import UIKit

struct TourImageService {
    private let sessionManager: SessionManagerProtocol
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    func search(url: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let imageUrl = URL(string: url) else {
            return
        }
        
        sessionManager.dataTask(with: imageUrl) { data, response, error in
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
