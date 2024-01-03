import Foundation

enum ErrorType: String, Error {
    case disconnected = "UE1006"
    case parsingError
    case unknown
}
