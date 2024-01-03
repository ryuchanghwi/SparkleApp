import Foundation
import Combine
import Alamofire
import Sentry

final class GetServiceCombine: GetServiceProtocol {
    static let shared = GetServiceCombine()
    private let session: Session
    init(session: Session = Session.default) {
          self.session = session
    }
    private let tokenUtils = HeaderUtils()
    func getService<T: Decodable>(from url: String, isUseHeader: Bool) -> AnyPublisher<T, ErrorType> {
        return Future<T, ErrorType> { promise in
            self.session.request(url,
                       method: .get,
                       encoding: JSONEncoding.default,
                       headers: isUseHeader ? self.tokenUtils.getAuthorizationHeader() : self.tokenUtils.getNormalHeader())
                .response { response in
                    do {
                        guard let resData = response.data else { promise(.failure(ErrorType.parsingError))
                            return
                        }
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
