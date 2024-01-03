import Foundation
import Combine

final class HomeGetRepository: HomeGetRepositoryInterface {
    private let service: GetServiceCombine
    init(service: GetServiceCombine) {
        self.service = service
    }
    func data() -> AnyPublisher<HomeGetDTO, ErrorType> {
        self.service.getService(from: Config.baseURL + "api/home", isUseHeader: true)
    }
}
