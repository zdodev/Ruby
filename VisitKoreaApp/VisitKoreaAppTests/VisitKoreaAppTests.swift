import XCTest
@testable import VisitKoreaApp

class VisitKoreaAppTests: XCTestCase {
    func test_관광API_JSON_디코딩_성공() {
        let sut = JSONAnalyzer()
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "TourInformationListSample", withExtension: "json") else {
            XCTFail()
            return
        }
        
        var data = Data()
        do {
            data = try Data(contentsOf: url)
        } catch {
            XCTFail()
        }
        
        guard let tourData = sut.decodeJSON(TourInformation.self, data: data) else {
            XCTFail()
            return
        }
        
        let expectedValue = "OK"
        XCTAssertEqual(tourData.response.header.resultMsg, expectedValue)
    }
}
