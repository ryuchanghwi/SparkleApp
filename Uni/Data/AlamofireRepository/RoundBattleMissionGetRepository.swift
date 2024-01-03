import Foundation
import Combine

final class RoundBattleMissionRepository: RoundBattleMissionRepositoryInterface {
    private let service: GetServiceCombine
    init(service: GetServiceCombine) {
        self.service = service
    }
    func data(roundId: Int) -> AnyPublisher<RoundBattleMissionDTO, ErrorType> {
        self.service.getService(from: Config.baseURL + "api/game/short/\(roundId)", isUseHeader: true)
    }
}
