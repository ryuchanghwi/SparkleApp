import Foundation

enum MisstionToolCase: String {
    case memo = "MEMO"
    case timer = "TIMER"
    case unknown = ""
}

struct RoundBattleMisstionItemViewData {
    let imagePath: URL?
    let misstionContent: String
    let misstionTitle: String
    let rule: String
    let tip: String
    let misstionTool: MisstionToolCase
    let roundBattleMissionDTO: RoundBattleMissionDTO
    init(roundBattleMissionDTO: RoundBattleMissionDTO) {
        self.roundBattleMissionDTO = roundBattleMissionDTO
        self.imagePath = URL(string: roundBattleMissionDTO.myRoundMission?.missionContent.missionCategory.image ?? "")
        self.misstionContent = roundBattleMissionDTO.myRoundMission?.missionContent.content ?? ""
        self.misstionTitle = roundBattleMissionDTO.myRoundMission?.missionContent.missionCategory.title ?? ""
        self.rule = roundBattleMissionDTO.myRoundMission?.missionContent.missionCategory.rule ?? ""
        self.tip = roundBattleMissionDTO.myRoundMission?.missionContent.missionCategory.tip ?? ""
        self.misstionTool = MisstionToolCase(rawValue: roundBattleMissionDTO.myRoundMission?.missionContent.missionCategory.missionTool ?? "") ?? .unknown
    }
}
