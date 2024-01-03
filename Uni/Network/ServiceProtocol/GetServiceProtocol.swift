import Combine

protocol GetServiceProtocol {
    func getService<T: Decodable>(from url: String, isUseHeader: Bool) -> AnyPublisher<T, ErrorType>
}
