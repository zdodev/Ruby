import XCTest
@testable import VisitKoreaApp

class VisitKoreaAppTests: XCTestCase {
    func test_관광API_TourInformationJSON_디코딩_성공() {
        let sut = JSONAnalyzer()
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "TourInformationSample", withExtension: "json") else {
            XCTFail("TourInformationSample 리소스를 찾을 수 없습니다.")
            return
        }
        var data = Data()
        do {
            data = try Data(contentsOf: url)
        } catch {
            XCTFail("TourInformationSample 리소스를 읽을 수 없습니다.")
        }
        
        guard let decodedData = sut.decodeJSON(TourInformation.self, data: data) else {
            XCTFail("TourInformationSample 리소스를 디코딩할 수 없습니다.")
            return
        }
        
        let expectedValue = "대구광역시 북구 호암로 15"
        XCTAssertEqual(decodedData.response.body.items.item[0].baseAddress, expectedValue)
    }
}
