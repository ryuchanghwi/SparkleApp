import Foundation

struct BattleHistoryResultDTO: Codable {
    
    let roundGameId: Int?
    let date: String?
    let result: String?
    let title: String?
    let image: String?
    let winner: String?
    let myMission: MyMission
    let partnerMission: PartnerMission
}

struct MyMission: Codable {
    let content: String?
    let result: String?
    let time: String?
}

struct PartnerMission: Codable {
    let content: String?
    let result: String?
    let time: String?
}

extension BattleHistoryResultDTO: Equatable {
    static func == (lhs: BattleHistoryResultDTO, rhs: BattleHistoryResultDTO) -> Bool {
        return lhs.roundGameId == rhs.roundGameId &&
            lhs.date == rhs.date &&
            lhs.result == rhs.result &&
            lhs.title == rhs.title &&
            lhs.image == rhs.image &&
            lhs.winner == rhs.winner &&
            lhs.myMission == rhs.myMission &&
            lhs.partnerMission == rhs.partnerMission
    }
}
extension MyMission: Equatable {}
extension PartnerMission: Equatable {}
