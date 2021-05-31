import Foundation

enum NetworkError: Error {
    case networkError
    case dataReceiveError
    case decodeError
}

struct TourAPIService {
    private let sessionManager: SessionManagerProtocol
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    func search<T: Decodable>(pageNumber: Int, type: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = makeURL(pageNumber) else {
            return
        }
        
        sessionManager.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let receivedData = data else {
                completionHandler(.failure(.dataReceiveError))
                return
            }
            
            let jsonAnalyzer = JSONAnalyzer()
            guard let decodedData = jsonAnalyzer.decodeJSON(type.self, data: receivedData) else {
                completionHandler(.failure(.decodeError))
                return
            }

            completionHandler(.success(decodedData))
        }.resume()
    }
    
    private func makeURL(_ pageNumber: Int) -> URL? {
        let urlAddress = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList"
        guard var urlComponent = URLComponents(string: urlAddress) else {
            return nil
        }
        urlComponent.queryItems = [URLQueryItem]()
        
        urlComponent.queryItems?.append(URLQueryItem(name: "serviceKey", value: ))
        urlComponent.queryItems?.append(URLQueryItem(name: "numOfRows", value: "10"))
        urlComponent.queryItems?.append(URLQueryItem(name: "MobileApp", value: "AppTest"))
        urlComponent.queryItems?.append(URLQueryItem(name: "MobileOS", value: "ETC"))
        urlComponent.queryItems?.append(URLQueryItem(name: "arrange", value: "A"))
        urlComponent.queryItems?.append(URLQueryItem(name: "contentTypeId", value: "15"))
        urlComponent.queryItems?.append(URLQueryItem(name: "areaCode", value: "4"))
        urlComponent.queryItems?.append(URLQueryItem(name: "sigunguCode", value: ""))
        urlComponent.queryItems?.append(URLQueryItem(name: "listYN", value: "Y"))
        urlComponent.queryItems?.append(URLQueryItem(name: "_type", value: "json"))
        urlComponent.queryItems?.append(URLQueryItem(name: "pageNo", value: "\(pageNumber)"))

        urlComponent.percentEncodedQuery = urlComponent.percentEncodedQuery?.removingPercentEncoding
        return urlComponent.url
    }
}
