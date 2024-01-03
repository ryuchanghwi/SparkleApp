import Foundation
import Combine

protocol HomeGetUseCaseProtocol {
    func excute() -> AnyPublisher<HomeGetDTO, ErrorType>
}

final class HomeGetUseCase: HomeGetUseCaseProtocol {
    private let homeGetRepository: HomeGetRepositoryInterface
    init(homeGetRepository: HomeGetRepositoryInterface) {
        self.homeGetRepository = homeGetRepository
    }
    func excute() -> AnyPublisher<HomeGetDTO, ErrorType> {
        return self.homeGetRepository.data()
    }
}
