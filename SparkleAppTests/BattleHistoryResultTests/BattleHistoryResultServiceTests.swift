import XCTest
import Combine
import Alamofire
@testable import Uni

final class BattleHistoryResultServiceTests: XCTestCase {
    var sut: GetServiceCombine!
    var battleHistoryResult: [BattleHistoryResultDTO]!
    var urlString: String!
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        let config = URLSessionConfiguration.af.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSesstion = Session(configuration: config)
        sut = GetServiceCombine(session: urlSesstion)
        urlString = Config.baseURL + "api/history"
    }

    override func tearDownWithError() throws {
        sut = nil
        cancellables = []
        battleHistoryResult = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }
    func test_승부히스토리서비스_조회성공_테스트() {
        battleHistoryResult = [
            BattleHistoryResultDTO(roundGameId: 753, date: "23.12.27", result: "WIN", title: "키워드 스무고개", image: "https://uni-sparkle.s3.ap-northeast-2.amazonaws.com/category/name%3Dtwenty+questions.png", winner: "빵빵아", myMission: MyMission(content: "에코백", result: "WIN", time: "20:58"), partnerMission: PartnerMission(content: "장미", result: "LOSE", time: "20:56")),
            BattleHistoryResultDTO(roundGameId: 752, date: "23.12.26", result: "WIN", title: "키워드 스무고개", image: "https://uni-sparkle.s3.ap-northeast-2.amazonaws.com/category/name%3Dtwenty+questions.png", winner: "빵빵아", myMission: MyMission(content: "청소기", result: "WIN", time: "18:06"), partnerMission: PartnerMission(content: "텀블러", result: "WIN", time: "18:06"))
        ]
        let jsonString = BattleHistoryResultConstants.battleHistoryResultJsonString
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        let expectation = self.expectation(description: "승부 히스토리 서비스 조회 성공")
        var receivedResult: [BattleHistoryResultDTO]?
        sut.getService(from: urlString, isUseHeader: true)
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    XCTFail("테스트 실패 \(error)")
                }
            } receiveValue: { [self] (responseData: [BattleHistoryResultDTO]) in
                receivedResult = responseData
                let unwrappedBattleHistoryResult = battleHistoryResult!
                XCTAssertEqual(receivedResult?[0].roundGameId, unwrappedBattleHistoryResult[0].roundGameId, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[0].date, unwrappedBattleHistoryResult[0].date, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[0].result, unwrappedBattleHistoryResult[0].result, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[0].title, unwrappedBattleHistoryResult[0].title, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[0].image, unwrappedBattleHistoryResult[0].image, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[0].winner, unwrappedBattleHistoryResult[0].winner, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[0].myMission, unwrappedBattleHistoryResult[0].myMission, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[0].partnerMission, unwrappedBattleHistoryResult[0].partnerMission, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[1].roundGameId, unwrappedBattleHistoryResult[1].roundGameId, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[1].date, unwrappedBattleHistoryResult[1].date, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[1].result, unwrappedBattleHistoryResult[1].result, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[1].title, unwrappedBattleHistoryResult[1].title, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[1].image, unwrappedBattleHistoryResult[1].image, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[1].winner, unwrappedBattleHistoryResult[1].winner, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[1].myMission, unwrappedBattleHistoryResult[1].myMission, "응답 데이터가 예상한 데이터와 다릅니다.")
                XCTAssertEqual(receivedResult?[1].partnerMission, unwrappedBattleHistoryResult[1].partnerMission, "응답 데이터가 예상한 데이터와 다릅니다.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        self.wait(for: [expectation], timeout: 5)
    }
    func test_승부히스토리서비스_응답모델파싱에러() {
        let expectation = self.expectation(description: "승부 히스토리 서비스 파싱 에러")
        MockURLProtocol.error = ErrorType.disconnected
        sut.getService(from: urlString, isUseHeader: true)
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let errorType):
                    XCTAssertEqual(ErrorType.parsingError, errorType)
                    expectation.fulfill()
                }
            } receiveValue: { (responseData: [BattleHistoryResultDTO]) in
                XCTFail("테스트 실패 - responseData가 실행되지 말아야함\(responseData)")
            }.store(in: &cancellables)
        self.wait(for: [expectation], timeout: 5)
    }
    func test_승부히스토리서비스_서버에서에러내려줄때_disConnected으로받는지확인() {
        let expectation = self.expectation(description: "disConnected 에러를 받게 됨")
        MockURLProtocol.stubResponseData = BattleHistoryResultConstants.battleHistoryResultDisconnectedJsonString.data(using: .utf8)
        sut.getService(from: urlString, isUseHeader: true)
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let errorType):
                    XCTAssertEqual(ErrorType.disconnected, errorType, "ErrorType 중 disconned 케이스에 해당해야 함")
                    expectation.fulfill()
                }
            } receiveValue: { (responseData: [BattleHistoryResultDTO]) in
                XCTFail("테스트 실패 - responseData가 실행되지 말아야함\(responseData)")
            }.store(in: &cancellables)
        self.wait(for: [expectation], timeout: 5)
    }
}
