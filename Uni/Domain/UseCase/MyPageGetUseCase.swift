import Foundation
import Combine

protocol MyPageGetUseCaseProtocol {
    func excute() -> AnyPublisher<MyPageGetDTO, ErrorType>
}

final class MyPageGetUseCase: MyPageGetUseCaseProtocol {
    private let myPageGetRepository: MyPageGetRepositoryInterface
    init(myPageGetRepository: MyPageGetRepositoryInterface) {
        self.myPageGetRepository = myPageGetRepository
    }
    func excute() -> AnyPublisher<MyPageGetDTO, ErrorType> {
        return self.myPageGetRepository.data()
    }
}
