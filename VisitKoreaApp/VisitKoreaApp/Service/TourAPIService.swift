import Foundation

enum NetworkError: Error {
    case networkError
}

struct TourAPIService {
    func search(pageNumber: Int, completionHandler: @escaping (Result<TourInformation, NetworkError>) -> Void) {
        guard let url = makeURL(pageNumber) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let receivedData = data else {
                completionHandler(.failure(.networkError))
                return
            }
            
            let jsonAnalyzer = JSONAnalyzer()
            guard let decodedData = jsonAnalyzer.decodeJSON(TourInformation.self, data: receivedData) else {
                completionHandler(.failure(.networkError))
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
        
        urlComponent.queryItems?.append(URLQueryItem(name: "serviceKey", value: "hm3Ng%2Bp0hajUH1lyqqB1JTmURPuIidiOj%2BoR1I49TQDEJPB9eY9CrArmUXrlx1PQ1DqvA%2B%2FqNSJWJhFa73mamw%3D%3D"))
        urlComponent.queryItems?.append(URLQueryItem(name: "numOfRows", value: "1"))
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
