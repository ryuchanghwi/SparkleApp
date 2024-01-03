import Foundation
import Combine

protocol RoundBattleMissionUseCaseProtocol {
    func execute(roundId: Int) -> AnyPublisher<RoundBattleMissionDTO, ErrorType>
}

final class RoundBattleMissionUseCase: RoundBattleMissionUseCaseProtocol {
    private let roundBattleMissionRepository: RoundBattleMissionRepositoryInterface
    init(roundBattleMissionRepository: RoundBattleMissionRepositoryInterface) {
        self.roundBattleMissionRepository = roundBattleMissionRepository
    }
    func execute(roundId: Int) -> AnyPublisher<RoundBattleMissionDTO, ErrorType> {
        return self.roundBattleMissionRepository.data(roundId: roundId)
    }
}
