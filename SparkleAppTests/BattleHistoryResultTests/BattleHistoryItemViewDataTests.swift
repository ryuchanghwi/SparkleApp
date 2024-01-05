import XCTest
@testable import Uni

final class BattleHistoryItemViewDataTests: XCTestCase {
    var sut: BattleHistoryItemViewData!
    var battleHistoryResult: BattleHistoryResultDTO!
    override func setUpWithError() throws {
        battleHistoryResult = BattleHistoryResultConstants.battleHistoryResultData[0]
        sut = BattleHistoryItemViewData(battleHistoryItem: battleHistoryResult)
    }
    override func tearDownWithError() throws {
        sut = nil
        battleHistoryResult = nil
    }
    func test_승부히스토리DTO를_View에서쓸수있는상태로변환확인() {
        XCTAssertEqual(sut.result, "승리")
        XCTAssertEqual(sut.date, battleHistoryResult.date!)
        XCTAssertEqual(sut.gameTitle, battleHistoryResult.title!)
        XCTAssertEqual(sut.imagePath, URL(string: battleHistoryResult.image!))
    }
}
