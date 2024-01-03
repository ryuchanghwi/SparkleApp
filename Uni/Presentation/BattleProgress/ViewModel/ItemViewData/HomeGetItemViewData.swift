import Foundation

struct BattleProgressHomeGetItemViewData {
    let roundId: Int
    let homeGetDTO: HomeGetDTO
    init(homeGetDTO: HomeGetDTO) {
        self.homeGetDTO = homeGetDTO
        self.roundId = homeGetDTO.roundGameId ?? 0
    }
}
