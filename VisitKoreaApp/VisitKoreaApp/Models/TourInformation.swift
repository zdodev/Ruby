struct TourInformation: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let header: Header
        let body: Body

        struct Header: Decodable {
            let resultCode: String
            let resultMsg: String
        }
        
        struct Body: Decodable {
            let items: Items
            let numOfRows: Int
            let pageNo: Int
            let totalCount: Int
            
            struct Items: Decodable {
                let item: Item
                
                struct Item: Decodable {
                    let title: String
                    let baseAddress: String
                    let detailAddress: String
                    let inquiringNumber: String
                    let imageURLAddress: String

                    enum CodingKeys: String, CodingKey {
                        case title
                        case baseAddress = "addr1"
                        case detailAddress = "addr2"
                        case inquiringNumber = "tel"
                        case imageURLAddress = "firstimage"
                    }
                }
            }
        }
    }
}
