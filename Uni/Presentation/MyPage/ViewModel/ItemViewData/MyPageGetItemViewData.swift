import Foundation

struct MyPageGetItemViewData {
    let name: String
    let date: String
    let myPageGetItem: MyPageGetDTO
    init(myPageGetItem: MyPageGetDTO) {
        self.myPageGetItem = myPageGetItem
        name = myPageGetItem.nickname ?? ""
        func formatDateString(rawValue: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: rawValue) else { return rawValue }
            dateFormatter.dateFormat = "yyyy.MM.dd (EEEE)"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            let formattedDateString = dateFormatter.string(from: date)
            let shortenedDateString = formattedDateString.replacingOccurrences(of: "요일", with: "")
              return shortenedDateString
        }
        date = formatDateString(rawValue: myPageGetItem.startDate ?? "")
    }
}
