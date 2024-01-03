import Foundation

struct MyPageGetDTO: Codable {
    let id: Int?
    let nickname: String?
    let image: String?
    let startDate: String?
    let couple: CoupleInfo?
}

struct CoupleInfo: Codable {
    let id: Int
    let startDate: String?
    let heartToken: Int
}
