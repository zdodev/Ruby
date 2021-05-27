import Foundation

struct JSONAnalyzer {
    func decodeJSON<T: Decodable>(_ type: T.Type, data: Data) -> T? {
        let jsonDecoder = JSONDecoder()
        
        do {
            let decodedData = try jsonDecoder.decode(type.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}
