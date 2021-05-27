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
    
    func test_pageNumber_파라미터를_전달하여_search_메서드_호출() {
        let sessionManagerStub = SessionManagerStub()
        let sut = TourAPIService(sessionManager: sessionManagerStub)
        
        sut.search(pageNumber: 1) { _ in }
        
        guard let url = sessionManagerStub.url else {
            XCTFail()
            return
        }
        let expectedURL = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?serviceKey=hm3Ng%2Bp0hajUH1lyqqB1JTmURPuIidiOj%2BoR1I49TQDEJPB9eY9CrArmUXrlx1PQ1DqvA%2B%2FqNSJWJhFa73mamw%3D%3D&numOfRows=1&MobileApp=AppTest&MobileOS=ETC&arrange=A&contentTypeId=15&areaCode=4&sigunguCode=&listYN=Y&_type=json&pageNo=1"
        XCTAssertEqual(url.absoluteString, expectedURL)
        sut.search(pageNumber: 1) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.response.header.resultMsg, "OK")
            case .failure(_):
                XCTFail()
            }
        }
    }
}
