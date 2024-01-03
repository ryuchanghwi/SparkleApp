import Foundation
import Combine

protocol HomeGetRepositoryInterface {
    func data() -> AnyPublisher<HomeGetDTO, ErrorType>
}
