import Foundation
import Combine
import Alamofire
import Sentry

final class PatchServiceCombine {
    static let shared = PatchServiceCombine()
    private init() {}
    private let tokenUtils = HeaderUtils()
    func patchService<T: Decodable>(with param: Parameters? = nil, isUseHeader: Bool, from url: String) -> AnyPublisher<T, ErrorType> {
        return Future<T, ErrorType> { promise in
            AF.request(url,
                       method: .patch,
            parameters: param,
                       encoding: JSONEncoding.default,
                       headers: isUseHeader ? self.tokenUtils.getAuthorizationHeader(): self.tokenUtils.getNormalHeader()).response { response in
                do {
                    guard let resData = response.data else { return }
                    let data = try JSONDecoder().decode(T.self, from: resData)
                    promise(.success(data))
                } catch {
                    do {
                        guard let resData = response.data else { return }
                        let errorCode = try JSONDecoder().decode(ErrorCode.self, from: resData)
                        promise(.failure(ErrorType(rawValue: errorCode.code) ?? .unknown))
                    } catch {
                        SentrySDK.capture(error: error)
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
