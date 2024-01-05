import XCTest
import Combine
import Alamofire
@testable import Uni

final class BattleHistoryResultViewModelTests: XCTestCase {
    var sut: BattleHistoryResultViewModel!
    var getServiceCombine: GetServiceCombine!
    var battleHistoryResult: [BattleHistoryResultDTO]!
    var urlString: String!
    var cancellables: Set<AnyCancellable> = []
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.af.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSesstion = Session(configuration: config)
        sut = BattleHistoryResultViewModel(battleHistoryResultUsecase: BattleHistoryResultUseCase(battleHistoryResultRepository: BattleHistoryResultRepository(service: GetServiceCombine(session: urlSesstion))))
        urlString = Config.baseURL + "api/history"
    }
    override func tearDownWithError() throws {
        sut = nil
        getServiceCombine = nil
        battleHistoryResult = nil
        urlString = nil
        cancellables = []
    }
    func test_BattleHistoryResultViewModel에_ViewLoad됐을때_battleHistoryResultData가반환_테스트() {
        // Expectation
        let expectation = expectation(description: "BattleHistoryResultDTO 데이터 조회 성공")
        // Given
        battleHistoryResult = BattleHistoryResultConstants.battleHistoryResultData
        let jsonString = BattleHistoryResultConstants.battleHistoryResultJsonString
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        let viewLoadTrigger = PassthroughSubject<Void, Never>()
        var expectationResults: [BattleHistoryResultDTO]?
        let output = sut.transform(input: BattleHistoryResultViewModel.Input(viewLoad: viewLoadTrigger.eraseToAnyPublisher()))
        output.loadBattleHistoryResultData
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let errorType):
                    XCTFail("테스트 실패 - 실패가 나와선 안되는 케이스\(errorType)")
                case .finished:
                    break
                }
            } receiveValue: { data in
                expectationResults = data
                expectation.fulfill()
            }.store(in: &cancellables)
        // When
        viewLoadTrigger.send()
        wait(for: [expectation], timeout: 5)
        // Then
        XCTAssertEqual(expectationResults, battleHistoryResult)
    }
    func test_BattleHistoryResultViewModel에_ViewLoad됐을때_에러타입_DisConnected에러가반환_테스트() {
        // Expectation
        let expectation = self.expectation(description: "disConnected 에러를 받게 됨")
        // Given
        MockURLProtocol.stubResponseData = BattleHistoryResultConstants.battleHistoryResultDisconnectedJsonString.data(using: .utf8)
        let viewLoadTrigger = PassthroughSubject<Void, Never>()
        var expectationResults: ErrorType?
        let output = sut.transform(input: BattleHistoryResultViewModel.Input(viewLoad: viewLoadTrigger.eraseToAnyPublisher()))
        output.loadBattleHistoryResultData
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let errorType):
                    expectationResults = errorType
                    expectation.fulfill()
                case .finished:
                    return
                }
            } receiveValue: { data in
                XCTFail("테스트 실패 - data가 실행되지 말아야함 \(data)")
            }.store(in: &cancellables)
        // When
        viewLoadTrigger.send()
        wait(for: [expectation], timeout: 5)
        // Then
        XCTAssertEqual(expectationResults, ErrorType.disconnected)
    }
}
