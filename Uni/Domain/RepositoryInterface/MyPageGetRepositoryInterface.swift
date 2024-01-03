import Foundation
import Combine

protocol MyPageGetRepositoryInterface {
    func data() -> AnyPublisher<MyPageGetDTO, ErrorType>
}
