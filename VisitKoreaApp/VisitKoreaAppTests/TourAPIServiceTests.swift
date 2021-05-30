import XCTest
@testable import VisitKoreaApp

class TourAPIServiceTests: XCTestCase {
    func test_관광API_요청_시_데이터_응답_성공() {
        let tourAPISessionManagerStub = TourAPISessionManagerStub()
        let sut = TourAPIService(sessionManager: tourAPISessionManagerStub)
        
        sut.search(pageNumber: 1, type: TourInformation.self) { result in
            switch result {
            case .success(let data):
                let title = data.response.body.items.item[0].title
                let expectedValue = "가족오페라 <마술피리> 2021"
                XCTAssertEqual(title, expectedValue, "요청한 관광API 데이터 title이 예상한 title이 아닙니다.")
            case .failure(_):
                XCTFail("관광API 요청에 실패하였습니다.")
            }
        }
        
        guard let host = tourAPISessionManagerStub.url?.host else {
            return
        }
        guard let path = tourAPISessionManagerStub.url?.path else {
            return
        }
        let url = host + path
        let expectedValue = "api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList"
        XCTAssertEqual(url, expectedValue, "요청한 URL이 예상한 URL이 아닙니다.")
    }
}
