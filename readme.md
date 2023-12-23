![한판승부 생성](https://github.com/ryuchanghwi/SparkleApp/assets/78063938/c3dcaedc-df9c-4623-ab92-f7ff51760a3a)

# 프로젝트 소개
- 연인 간 미션 승부를 통한 소원권 내기 서비스 앱

🔗 [앱 다운로드 링크](https://apps.apple.com/kr/app/sparkle-%EC%8A%A4%ED%8C%8C%ED%81%B4-%EC%97%B0%EC%95%A0%EC%97%90-%EC%83%88%EB%A1%9C%EC%9A%B4-%EC%A7%9C%EB%A6%BF%ED%95%A8%EC%9D%B4-%ED%95%84%EC%9A%94%ED%95%A0%EB%95%8C/id6451497605)



<img src="https://github.com/ryuchanghwi/swiftAlgorithim/assets/78063938/72d6e048-adea-4e08-9f1b-96735acdcfd4" width=150></img>&nbsp;&nbsp;<img src="https://github.com/ryuchanghwi/swiftAlgorithim/assets/78063938/0f823165-d0ac-4764-9d2a-7c5d94397974" width=150></img>&nbsp;&nbsp;<img src="https://github.com/ryuchanghwi/swiftAlgorithim/assets/78063938/01f09ef6-94b3-499d-a201-c35003988225" width=150></img>&nbsp;&nbsp;<img src="https://github.com/ryuchanghwi/swiftAlgorithim/assets/78063938/c167a1b6-3b9f-46a5-a8eb-be59614469ac" width=150></img>&nbsp;&nbsp;<img src="https://github.com/ryuchanghwi/swiftAlgorithim/assets/78063938/74bebcea-5770-43bc-adca-52b69c8e583b" width=150></img>

- 진행 기간
    - 개발 : 2023.07 ~ 2023.12(진행중)
- 출시
    - 1.0.0 : 2023.12.11
    - 1.0.1 : 2023.12.22(타이머, 로그인 수정)
- 기술 스택
    - iOS : UIKit, SwiftUI, Combine, SwiftLint 
    - Deployment Target : iOS 15.0
  
# Architecture
## MVC -> MVVM + Clean Architecture(진행 중)
- 잦은 기획 변경 및 유지보수 등 업무 효율을 높이기 위해 `클린 아키텍처`를 도입중입니다.
<img width="1152" src="https://github.com/U-is-Ni-in-Korea/iOS-United/assets/78063938/d24e3dc0-c3ca-421d-99da-cc1cfcba6e71">

## Domain
> Entity
- 서비스에 쓰이는 데이터를 정의합니다. 서버와의 소통 오류로 런타임에러를 막기 위해 `옵셔널`로 처리했습니다. 
``` swift
struct BattleHistoryResultDTO: Codable {
    let roundGameId: Int?
    let date: String?
    let result: String?
    let title: String?
    let image: String?
    let winner: String?
    let myMission: MyMission
    let partnerMission: PartnerMission
}
```
> UseCase
- Entity가 사용되는 시나리오를 정의합니다. 
``` swift
protocol BattleHistoryResultUseCaseProtocol {
    func execute() -> AnyPublisher<[BattleHistoryResultDTO], ErrorType>
}

final class BattleHistoryResultUseCase: BattleHistoryResultUseCaseProtocol {
    private let battleHistoryResultRepository: BattleHistoryResultRepositoryInterface
    init(battleHistoryResultRepository: BattleHistoryResultRepositoryInterface) {
        self.battleHistoryResultRepository = battleHistoryResultRepository
    }
    func execute() -> AnyPublisher<[BattleHistoryResultDTO], ErrorType> {
        return self.battleHistoryResultRepository.data()
    }
}
```
> Repository Interface
- 클린 아키텍처 다이어그램의 더 안쪽에 위치한 Domain 영역이 Data 영역의 Repository에 접근하기 위해 `의존성 역전`를 통해 레퍼지토리에 접근하기 위한 방법을 제공합니다.
``` swift
protocol RoundBattleMissionRepositoryInterface {
    func data(roundId: Int) -> AnyPublisher<RoundBattleMissionDTO, ErrorType>
}
```
## Data
> Repository
- 데이터를 직접적으로 획득합니다. 데이터를 획득하는 방법을 확장성있도록 하기 위해 사용됩니다.
``` swift
final class RoundBattleMissionRepository: RoundBattleMissionRepositoryInterface {
    private let service: GetServiceCombine
    init(service: GetServiceCombine) {
        self.service = service
    }
    func data(roundId: Int) -> AnyPublisher<RoundBattleMissionDTO, ErrorType> {
        self.service.getService(from: Config.baseURL + "api/game/short/\(roundId)", isUseHeader: true)
    }
}
```
## Presentation
> View
- 기존 MVC 패턴 시 UIViewController의 `loadView` 생명주기에 UIView를 바꿔주어 ViewController의 레이아웃 코드를 최소화하고자 했습니다.
``` swift
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        historyView = HistoryView(frame: self.view.frame)
        self.view = historyView
    }
```
- 현재는 UIHostingController를 사용해 SwiftUI로 UI를 구성하고 있습니다.
``` swift
    // MARK: - Setting
    override func setConfig() {
        battleHistoryHostingController = UIHostingController(rootView: BattleProgressView(data: battleHistoryViewData))
        self.addChild(battleHistoryHostingController)
        view.addSubview(battleHistoryHostingController.view)
        battleHistoryHostingController.didMove(toParent: self)
    }
    override func setLayout() {
        battleHistoryHostingController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
```
> ViewModel
- SwiftUI와 UIKit에 모두 비동기프로그래밍을 적용하고자 `Combine`을 학습 중입니다.
- UIKit의 ViewModel은 `Input/Output Modeling`을 통해 View로부터 전달된 이벤트는 Input, View로 전달할 데이터는 Output을 통해 Binding합니다.
``` swift
struct BattleHistoryDetailViewModel {
    struct Input {
        let viewLoad: AnyPublisher<BattleHistoryResultDTO, Never>
    }
    struct Output {
        let historyDetailData: AnyPublisher<BattleHistoryDetailItemViewData, Never>
    }
    func transform(input: Input) -> Output {
        let historyData = input.viewLoad.map {
            return BattleHistoryDetailItemViewData(battleHistoryItem: $0)
        }.eraseToAnyPublisher()
        return Output(historyDetailData: historyData)
    }
}
```
- SwiftUI의 ViewModel은 `ObservableObject`와 `@Published`프로퍼티 패턴를 활용해 Binding합니다.
``` swift
final class MyPageViewModel: ObservableObject {
    @Published var myPageName: String = ""
    @Published var myPageDate: String = ""
    @Published var startDate: String = ""
    private var cancellables: Set<AnyCancellable> = []
    private let myPageGetUseCase: MyPageGetUseCaseProtocol
    private let navigationController: UINavigationController
    private let viewController: UIViewController
    init(myPageGetUseCase: MyPageGetUseCaseProtocol, navigationController: UINavigationController, viewController: UIViewController) {
        self.myPageGetUseCase = myPageGetUseCase
        self.navigationController = navigationController
        self.viewController = viewController
        getMyPageData()
    }
    // MARK: - Custom Method
    func getMyPageData() {
        myPageGetUseCase.excute().sink { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .failure(let errorType):
                errorResponse(status: errorType)
            case .finished:
                break
            }
        } receiveValue: { [weak self] data in
            guard let self = self else { return }
            self.myPageDate = MyPageGetItemViewData(myPageGetItem: data).date
            self.myPageName = MyPageGetItemViewData(myPageGetItem: data).name
            self.startDate = data.startDate ?? ""
        }
        .store(in: &cancellables)
    }
}
```
> ItemViewData
- Entity를 View에서 쉽게 사용하기 위한 데이터로 변환하는 작업을 수행합니다.
``` swift
struct BattleHistoryItemViewData {
    let date: String
    let gameTitle: String
    let imagePath: URL?
    let result: String
    let battleHistoryItem: BattleHistoryResultDTO
    init(battleHistoryItem: BattleHistoryResultDTO) {
        self.battleHistoryItem = battleHistoryItem
        self.date = battleHistoryItem.date ?? ""
        self.gameTitle = battleHistoryItem.title ?? ""
        self.imagePath = URL(string: battleHistoryItem.image ?? "")
        switch battleHistoryItem.result {
        case "DRAW":
            self.result = "무승부"
        case "WIN":
            self.result = "승리"
        case "LOSE":
            self.result = "패배"
        default:
            self.result = battleHistoryItem.result ?? ""
        }
    }
}
```

# ⚠️Trouble Shooting
### [1.SwiftUI View의 성능 향상을 위한 종속성 최소화](https://declan.tistory.com/89)
### 문제점
SwiftUI를 사용하면서 화면이 매끄럽지 않게 느껴지는 경우를 종종 발견함. 이에 따라 SwiftUI의 성능 향상을 위한 고민의 필요성을 느낌
### 해결 방안
두 가지 방법으로 해결하고자 했습니다. 
 1. 뷰를 하위 뷰로 나누기
- 뷰를 하나의 뷰로 작성한다면 그에 필요한 데이터 값이 변경됨에 따라 뷰가 다시 그려지게 됩니다. 예를 들어 10개의 버튼이 있으면 각 버튼이 눌릴 때마다 각각의 버튼에 해당하는 뷰만 다시 그려지게 할 수 있지만 하나의 전체 뷰가 다시 그려지게 되면 성능의 차이가 나게 될 것입니다.
- 다음과 같이 데이터가 바뀔 때마다 상관없는 뷰가 다시 그려지는 것을 막고자 했습니다.
      
<img src="https://github.com/ryuchanghwi/SparkleApp/assets/78063938/1dc8071f-9696-4d95-8a3c-cddac0e8ef90" width=200></img>&nbsp;&nbsp;

- 아래의 코드와 같이 하위 컨테이너 뷰로 나누게 되면 상위 뷰의 데이터가 다시 그려지는 것과 별개로 다시 뷰가 그려지지 않기 떄문에 성능 향상을 얻을 수 있습니다. 

`하위 뷰 분리로 개선한 코드`
``` swift
struct TimerTimeTextView: View {
    // MARK: - Property
    let text: String
    // MARK: - UI Property
    var body: some View {
        Text(text)
            .font(Font(SDSFont.body1.font))
            .foregroundColor(Color(.gray600))
            .background(.random)
    }
}
```
 2. 뷰가 꼭 필요한 종속성만을 갖게 하기
- 다음과 같은 코드를 통해 종속성을 체크하고 있습니다. 
``` swift
let _ = Self._printChanges()
```


<img src="https://github.com/ryuchanghwi/SparkleApp/assets/78063938/9874471d-ec02-4c4c-9c95-2c3cef06c6cc" width=200></img>&nbsp;&nbsp;

- ObservableObject에 종속성을 가지고 있는 경우 타이머가 흐름에 따라 데이터가 변화되는 것을 알 수 있었습니다.

`종속성을 최소화 하면서 개선한 코드`
``` swift
  TimerProgressView(remainingTime: timerData.remainingTime, totalTime: timerData.totalTime, isTimerRunning: timerData.isTimerRunning)
     .padding(.horizontal, 24)
     .padding(.top, 32)
```
- 다음과 같이 뷰가 ObservableObject에 종속성을 가지는 것이 아니라 필요한 데이터만을 가지게 됨으로써 업데이트 횟수를 줄일 수 있었습니다.
  

### 2. UIKit에서 SwiftUI를 사용할 때 주의할 점
### 문제점
SwiftUI를 사용하면서 간헐적으로 화면이 나타나지 않는 문제 발생

<img src="https://github.com/ryuchanghwi/SparkleApp/assets/78063938/4bb2dcc3-ea80-42dc-b5d3-f82e04addc8c" width=200></img>&nbsp;&nbsp;




### 해결 방안

## 📱 주요 화면 및 기능

> 🔖 로그인 플로우 - 카카오, 애플로 로그인을 할 수 있어요. 커플이 연결되어 있다면 홈 화면, 없다면 커플을 연결하는 플로우로 넘어가요.
<div align=leading>
<img src="https://github.com/workoutDone/WorkoutDone/assets/78063938/6499da78-a979-4c00-a97f-dffa8d99d3eb" width=200>
</div>

> 📈 몸무게, 체지방량, 골격근량 입력 및 분석 플로우 - 날마다 입력한 신체 정보를 차트로 한 눈에 비교할 수 있어요.
<div align=leading>
<img src="https://github.com/workoutDone/WorkoutDone/assets/78063938/882f39dd-fbd4-4c44-b0ca-62dac80456ff" width=200>
</div>

> 📸 오운완 사진 촬영 및 저장 플로우 - 날마다 사진을 찍고 저장해 몸의 변화를 한 눈에 비교할 수 있어요.

<div align=leading>
<img src="https://github.com/workoutDone/WorkoutDone/assets/78063938/8fbdb630-9457-4321-9372-8df07ba5a66b" width=200>
</div>



> 🎞️ 승부 생성 - 커플이 함께 할 수 있는 게임을 생성할 수 있어요. 이미 상대가 게임을 생성했다면 생성할 수 없다는 알람이 나타나요
<div align=leading>
  <img src="https://github.com/ryuchanghwi/SparkleApp/assets/78063938/77e4abcf-a234-4d1c-b4f8-7f0cb43b11f7" width=200>
    <img src="https://github.com/ryuchanghwi/SparkleApp/assets/78063938/02c21c41-231a-4161-9340-818483acd1af" width=200>
</div>

> 🎞️ 승부 결과 확인 - 갤러리(전체 권한, 선택 권한)에서 가져와 몸의 변화를 한 눈에 비교할 수 있어요.
<div align=leading>
  <img src="https://github.com/workoutDone/WorkoutDone/assets/78063938/7df2e2a9-d367-4b13-b8f4-3533c2b3bdd0" width=200>
    <img src="https://github.com/workoutDone/WorkoutDone/assets/78063938/c0aedb59-4c24-417f-8953-115e8b4514ae" width=200>
  <img src="https://github.com/workoutDone/WorkoutDone/assets/78063938/05b0c1ac-52ef-40c0-89b6-0781d54a7775" width=200>
</div>

> 💪 승부 히스토리 플로우 - 커플과 함께 한 승부의 기록들을 확인할 수 있어요
<div align=leading>
<img src="https://github.com/ryuchanghwi/SparkleApp/assets/78063938/1c59e30d-bc3a-4db9-8cdf-42b80fdfcc97" width=200>
</div>

> 🏋️ 마이페이지 플로우 - 내 정보를 수정할 수 있고 로그아웃, 커플 연결 끊기, 계정 탈퇴를 할 수 있어요.
<div align=leading>
<img src="https://github.com/workoutDone/WorkoutDone/assets/78063938/1b2d3003-a99a-4bac-987d-7439bad022b3" width=200>
  <img src="https://github.com/workoutDone/WorkoutDone/assets/78063938/bd8b9821-47ff-4769-bc94-e4afb84fb782" width=200>
</div>

# Commit message

```swift
🔨[FIX] : 버그, 오류 해결
➕[ADD] : Feat 이외의 부수적인 코드 추가, 라이브러리 추가, 새로운 파일 생성 시
✨[FEAT] : 새로운 기능 구현
✅[CHORE] : 코드 수정, 내부 파일 수정
⚰️[DEL] : 쓸모없는 파일,코드 삭제
♻️[REFACTOR] : 전면 수정이 있을 때 사용합니다
🔀[MERGE]: 다른브렌치를 merge 할 때 사용합니다.
```

# 코드 컨벤션

<details>
<summary> 🍎 네이밍 </summary>
<div markdown="1">

### 💧클래스, 구조체

- **UpperCamelCase** 사용

```swift
// - example

struct MyTicketResponseDTO {
}

class UserInfo {
}
```

### 💧함수

- **lowerCamelCase** 사용하고 동사로 시작

```swift
// - example

private func setDataBind() {
}
```

### 💧**뷰 전환**

- pop, push, present, dismiss
- 동사 + To + 목적지 뷰 (다음에 보일 뷰)
- dismiss는 dismiss + 현재 뷰

```swift
// - example pop, push, present

popToFirstViewController()
pushToFirstViewController()
presentToFirstViewController()

dismissFirstViewController()
```

### 💧**register**

- register + 목적어

```swift
// - example

registerXib()
registerCell()
```

### 💧서버 통신

- 서비스함수명 + WithAPI

```swift
// - example

fetchListWithAPI()

requestListWithAPI()
```

fetch는 무조건 성공

request는 실패할 수도 있는 요청

### 💧애니메이션

- 동사원형 + 목적어 + WithAnimation

```swift
showButtonsWithAnimation()
```

### 💧**델리게이트**

delegate 메서드는 프로토콜명으로 네임스페이스를 구분

**좋은 예:**

```swift
protocol UserCellDelegate {
  func userCellDidSetProfileImage(_ cell: UserCell)
  func userCell(_ cell: UserCell, didTapFollowButtonWith user: User)
}

protocol UITableViewDelegate {
    func tableview( ....) 
    func tableview...
}

protocol JunhoViewDelegate {
    func junhoViewTouched()
    func junhoViewScrolled()
}
```

Delegate 앞쪽에 있는 단어를 중심으로 메서드 네이밍하기

**나쁜 예:**

```swift
protocol UserCellDelegate {
    // userCellDidSetProfileImage() 가 옳음
  func didSetProfileImage()
  func followPressed(user: User)

  // `UserCell`이라는 클래스가 존재할 경우 컴파일 에러 발생  (userCell 로 해주자)
  func UserCell(_ cell: UserCell, didTapFollowButtonWith user: User)
}
```

함수 이름 앞에는 되도록이면 `get` 을 붙이지 않습니다.

### 💧**변수, 상수**

- **lowerCamelCase** 사용

```swift
let userName: String
```

### 💧**열거형**

- 각 case 에는 **lowerCamelCase** 사용

```swift
enum UserType {
    case viewDeveloper
    case serverDeveloper
}
```

### 💧**약어**

약어로 시작하는 경우 소문자로 표기, 그 외에는 항상 대문자

```swift
// 좋은 예:
let userID: Int?
let html: String?
let websiteURL: URL?
let urlString: String?
```

```swift
// 나쁜 예:
let userId: Int?
let HTML: String?
let websiteUrl: NSURL?
let URLString: String?
```

### 💧**기타 네이밍**

```swift
setUI() : @IBOutlet 속성 설정
setLayout() : 레이아웃 관련 코드
setDataBind() : 배열 항목 세팅. 컬렉션뷰 에서 리스트 초기 세팅할때
setAddTarget() : addtarget 모음
setDelegate() : delegate, datasource 모음
setCollectionView() : 컬렉션뷰 관련 세팅
setTableView() : 테이블뷰 관련 세팅
initCell() : 셀 데이터 초기화
registerXib() : 셀 xib 등록.
setNotification() : NotificationCenter addObserver 모음

헷갈린다? set을 쓰세요 ^^

```
</details>

<details>
<summary> 🍎 코드 레이아웃 </summary>
<div markdown="1">

### 💧**들여쓰기 및 띄어쓰기**

- 들여쓰기에는 탭(tab) 대신 **4개의 space**를 사용합니다.
- 콜론(`:`)을 쓸 때에는 콜론의 오른쪽에만 공백을 둡니다.
    
    `let names: [String: String]?`
    
    `let name: String`
    
- 연산자 오버로딩 함수 정의에서는 연산자와 괄호 사이에 한 칸 띄어씁니다.
    
    `func ** (lhs: Int, rhs: Int)`
    

### 💧**줄바꿈**

- 함수를 호출하는 코드가 최대 길이를 초과하는 경우에는 파라미터 이름을 기준으로 줄바꿈합니다.
**파라미터가 3개 이상이면 줄바꿈하도록!!**
    
    **단, 파라미터에 클로저가 2개 이상 존재하는 경우에는 무조건 내려쓰기합니다.**
    
    ```swift
    UIView.animate(
      withDuration: 0.25,
      animations: {
        // doSomething()
      },
      completion: { finished in
        // doSomething()
      }
    )
    ```
    
- `if let` 구문이 길 경우에는 줄바꿈하고 한 칸 들여씁니다.
    
    ```swift
    if let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
      let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
      user.gender == .female {
      // ...
    }
    ```
    
- `guard let` 구문이 길 경우에는 줄바꿈하고 한 칸 들여씁니다. `else`는 마지막 줄에 붙여쓰기
    
    ```swift
    guard let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
      let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
      user.gender == .female else { return }
    
    guard let self = self 
    else { return } (X)
    
    guard let self = self else { return } (O)

    ```
- else 구문이 길 시 줄바꿈
  

### 💧**빈 줄**

- 클래스 선언 다음에 , extension 다음에 한 줄 띄어주기
- 빈 줄에는 공백이 포함되지 않도록 합니다.  ( 띄어쓰기 쓸데없이 넣지 말기 )
- 모든 파일은 빈 줄로 끝나도록 합니다. ( 끝에 엔터 하나 넣기)
- MARK 구문 위와 아래에는 공백이 필요합니다.
    
    ```swift
    // MARK: Layout
    
    override func layoutSubviews() {
      // doSomething()
    }
    
    // MARK: Actions
    
    override func menuButtonDidTap() {
      // doSomething()
    }
    ```
    

### 💧**임포트**

모듈 임포트는 알파벳 순으로 정렬합니다. 내장 프레임워크를 먼저 임포트하고, 빈 줄로 구분하여 서드파티 프레임워크를 임포트합니다.

```swift
import UIKit

import Moya
import SnapKit
import SwiftyColor
import Then
```

```swift
import UIKit

import SwiftyColor
import SwiftyImage
import JunhoKit
import Then
import URLNavigator
```

</details>


<details>
<summary> 🍎 클로저 </summary>
<div markdown="1">

- 파라미터와 리턴 타입이 없는 Closure 정의시에는 `() -> Void`를 사용합니다.
    
    **좋은 예:**
    
    ```
    let completionBlock: (() -> Void)?
    ```
    
    **나쁜 예:**
    
    `let completionBlock: (() -> ())? let completionBlock: ((Void) -> (Void))?`
    
- Closure 정의시 파라미터에는 괄호를 사용하지 않습니다.
    
    **좋은 예:**
    
    ```swift
    { operation, responseObject in
      // doSomething()
    }
    ```
    
    **나쁜 예:**
    
    ```swift
    { (operation, responseObject) in
      // doSomething()
    }
    ```
    
- Closure 정의시 가능한 경우 타입 정의를 생략합니다.
    
    **좋은 예:**
    
    ```swift
    ...,
    completion: { finished in
      // doSomething()
    }
    ```
    
    **나쁜 예:**
    
    ```swift
    ...,
    completion: { (finished: Bool) -> Void in
      // doSomething()
    }
    
    completion: { data -> Void in
      // doSomething()
    } (X)
    ```
    
- Closure 호출시 또다른 유일한 Closure를 마지막 파라미터로 받는 경우, 파라미터 이름을 생략합니다.
    
    **좋은 예:**
    
    ```swift
    UIView.animate(withDuration: 0.5) {
      // doSomething()
    }
    ```
    
    **나쁜 예:**
    
    ```swift
    UIView.animate(withDuration: 0.5, animations: { () -> Void in
      // doSomething()
    })
    ```
    
</details>

<details>
<summary> 🍎 주석 </summary>
<div markdown="1">

코드는 가능하면 자체적으로 문서가 되어야 하므로, 코드와 함께 있는 인라인(inline) 주석은 피한다.

### 💧**MARK 주석**

```swift
class ViewController: UIViewController {
    // MARK: - Property
    // MARK: - UI Property
    // MARK: - Life Cycle
    // MARK: - Setting
    // MARK: - Action Helper
    // MARK: - @objc Methods
    // MARK: - Custom Method
}

// MARK: - Extensions
```


### 💧**퀵헬프 주석**

커스텀 메서드, 프로토콜, 클래스의 경우에 퀵헬프 주석 달기

```swift
/// (서머리 부분)
/// (디스크립션 부분)
class MyClass {
    let myProperty: Int

    init(myProperty: Int) {
        self.myProperty = myProperty
    }
}

/**summary
(서머리 부분)
> (디스크립션 부분)

- parameters:
    - property: 프로퍼티
- throws: 오류가 발생하면 customError의 한 케이스를 throw
- returns: "\\(name)는 ~" String
*/
func printProperty(property: Int) {
        print(property)
    }

```

- 참고 :

</details>

<details>
<summary> 🍎 프로그래밍 권장사항 </summary>
<div markdown="1">

### 💧**Type Annotation 사용**

**좋은 예:**

```swift
let name: String = "철수"
let height: Float = "10.0"
```

**나쁜 예:**

```swift
let name = "철수"
let height = "10.0"
```

### 💧**UICollectionViewDelegate, UICollectionViewDatsource 등 시스템 프로토콜**

프로토콜을 적용할 때에는 extension을 만들어서 관련된 메서드를 모아둡니다.

**좋은 예**:

```swift
final class MyViewController: UIViewController {
  // ...
}

// MARK: - UITableViewDataSource

extension MyViewController: UITableViewDataSource {
  // ...
}

// MARK: - UITableViewDelegate

extension MyViewController: UITableViewDelegate {
  // ...
}
```

**나쁜 예:**

```swift
final class MyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  // ...
}

// 프로토콜 여러개를 한곳에 몰아서 때려넣지 말자!
```

</details>


<details>
<summary> 🍎 기타규칙 </summary>
<div markdown="1">

- `self` 는 최대한 사용을 지양 → `**알잘딱깔센 self…**`
- `viewDidLoad()` 에서는 함수호출만
- delegate 지정, UI관련 설정 등등 모두 함수와 역할에 따라서 extension 으로 빼기
- 필요없는 주석 및 Mark 구문들 제거
- `deinit{}` 모든 뷰컨에서 활성화
- `guard let` 으로 unwrapping 할 시, nil 가능성이 높은 경우에는 `else{}` 안에 `print()` 해서 디버깅하기 쉽게 만들기
- `return` 사용시 두 줄 이상 코드가 있을 시, 한 줄 띄고 `return` 사용
    
    ```swift
    func fetchFalse() -> Bool {
            return false
    } (O)
    
    func isDataValid(data: Data?) -> Bool {
            guard let data else { return false }
            
            return true
    } (O)
    
    func isDataValid(data: Data?) -> Bool {
            guard let data else {
                    return false 
            }
            return true
    } (X)
    ```
    
    ### 추가 규칙
    
    - `약어 지양`
    → TVC보다는 TableViewCell
    
    ### Function naming Rule
    
    - **set_ 형태로 작성**
    → setUI, setData
        - `setLayout()`, `setStyle()`, `setDelegate()`
    
    ### MARK 주석
    
    ```swift
    class ViewController: UIViewController {
        // MARK: - Property
        // MARK: - UI Property
        // MARK: - Life Cycle
            // MARK: - Setting
        // MARK: - Action Helper
        // MARK: - Custom Method
    }
    
    // MARK: - UITableView Delegate
    ```
    
    - 마크 주석 미사용시 삭제
    
    ### 프로퍼티 생성은 레이아웃 순서대로지만,  collectionView, tableView는 최상단에 적읍시다
    
    ```swift
    private let tableView: UITableView = {
            let view = UITableView()
            // ...
            return view
    }()
    
    private let view = UIView()
    
    private let view2 = UIView()
    ```
    
    ### 뷰의 생명주기를 담당하는 함수 안에는, 직접적인 구현 보다는 함수 호출만 진행
    
    ```swift
    ~~override viewDidLoad() {
            super.viewDidLoad()
            self.view.addsubView(uniView)
    }~~
    ```
    
    ```swift
    override viewDidLoad() {
            super.viewDidLoad()
            self.addUniView()
    }
    private func addUniView() {
            super.viewDidLoad()
            self.view.addsubView(uniView)
    }
    
    ```
    
</details>
    
   

# foldering 
<img width="690" alt="image" src="https://github.com/GGumPiece/GGumPiece_iOS/assets/73978827/f9f017d4-e0db-49d9-8587-fe9997f2a063">


# 가용 라이브러리

SPM을 이용

```swift
Kingfisher //이미지처리
Alamofire // 네트워크
Snapkit //레이아웃
Then //코드 간결화
Sentry //error tracking
kakao-ios-sdk //socialLogin
firebase-auth //socialLogin

```
