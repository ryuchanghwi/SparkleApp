import Foundation
import Combine

protocol RoundBattleMissionRepositoryInterface {
    func data(roundId: Int) -> AnyPublisher<RoundBattleMissionDTO, ErrorType>
}
