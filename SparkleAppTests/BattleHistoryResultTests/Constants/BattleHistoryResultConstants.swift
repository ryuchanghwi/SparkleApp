import Foundation

struct BattleHistoryResultConstants {
    static let battleHistoryResultDisconnectedJsonString = """
        {
            "code": "UE1006"
        }
    """
    static let battleHistoryResultJsonString = """
        [
            {
                "roundGameId": 753,
                "date": "23.12.27",
                "result": "WIN",
                "title": "키워드 스무고개",
                "image": "https://uni-sparkle.s3.ap-northeast-2.amazonaws.com/category/name%3Dtwenty+questions.png",
                "winner": "빵빵아",
                "myMission": {
                    "content": "에코백",
                    "result": "WIN",
                    "time": "20:58"
                },
                "partnerMission": {
                    "content": "장미",
                    "result": "LOSE",
                    "time": "20:56"
                }
            },
            {
                "roundGameId": 752,
                "date": "23.12.26",
                "result": "WIN",
                "title": "키워드 스무고개",
                "image": "https://uni-sparkle.s3.ap-northeast-2.amazonaws.com/category/name%3Dtwenty+questions.png",
                "winner": "빵빵아",
                "myMission": {
                    "content": "청소기",
                    "result": "WIN",
                    "time": "18:06"
                },
                "partnerMission": {
                    "content": "텀블러",
                    "result": "WIN",
                    "time": "18:06"
                }
            }
        ]
        """
}
