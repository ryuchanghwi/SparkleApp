import Foundation
import Combine

final class MyPageGetRepository: MyPageGetRepositoryInterface {
    private let service: GetServiceCombine
    init(service: GetServiceCombine) {
        self.service = service
    }
    func data() -> AnyPublisher<MyPageGetDTO, ErrorType> {
        self.service.getService(from: Config.baseURL + "api/user", isUseHeader: true)
    }
}
