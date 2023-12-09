import Foundation
import Alamofire

enum HistoryError: String, Error {
    case disconnectCouple = "UE1006"
    case unknown
}

class HistoryRepository {
    func getHistoryData(completion: @escaping ((Result<[HistoryDataModel], HistoryError>) -> Void)) {
        GetService.shared.getService(from: Config.baseURL + "api/history", isUseHeader: true) { (data: [HistoryDataModel]?, error) in
            if let data = data {
                completion(.success(data))
            } else {
                let errorCode = HistoryError(rawValue: error ?? "") ?? .unknown
                completion(.failure(errorCode))
            }
        }
    }
}
