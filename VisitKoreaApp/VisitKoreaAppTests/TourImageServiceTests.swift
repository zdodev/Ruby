import XCTest
@testable import VisitKoreaApp

class TourImageServiceTests: XCTestCase {
    func test_이미지_요청_시_데이터_응답_성공() {
        let sut = TourImageService(sessionManager: TourImageServiceSessionManagerStub())
        guard let url = URL(string: "http://tong.visitkorea.or.kr/cms/resource/60/2705060_image2_1.jpg") else {
            XCTFail("이미지 urlString URL 타입으로 변환에 실패하였습니다.")
            return
        }
        
        sut.downloadImage(url: url) { result in
            switch result {
            case .success(let data):
                guard let expectedValue = UIImage(systemName: "photo")?.pngData() else {
                    XCTFail("이미지 데이터 변환에 실패하였습니다.")
                    return
                }
                XCTAssertEqual(data, expectedValue, "요청한 이미지와 예상한 이미지가 다릅니다.")
            case .failure(_):
                XCTFail("이미지 요청에 실패하였습니다.")
            }
        }
    }
}
