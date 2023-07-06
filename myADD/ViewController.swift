import UIKit
import FSCalendar
import CardSlider

struct Item: CardSliderItem {
    var image: UIImage
    var rating: Int?
    var title: String
    var subtitle: String?
    var description: String?
}

class ViewController: UIViewController, CardSliderDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet var myButton: UIButton! // my ADD 정보 버튼
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!

    var data = [Item]()
    var events: [Date] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Label 구현
        let name = "홍길동" // 유저의 이름
        let count = 24 // count(저장한 ADD 개수)
        updateLabel(withName: name, andCount: count)
        //

        // 네비게이션 바 구현
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        //
        
        // Configure card data
        data.append(Item(image: UIImage(named: "movie.png")!,
                         rating: nil,
                         title: "영화 제목",
                         subtitle: "플랫폼",
                         description: "You can add ADD in the app right now"))

        data.append(Item(image: UIImage(named: "lastofus.png")!,
                         rating: nil,
                         title: "영화 제목",
                         subtitle: "플랫폼",
                         description: "You can add ADD in the app right now"))

        data.append(Item(image: UIImage(named: "Avengers.png")!,
                         rating: nil,
                         title: "영화 제목",
                         subtitle: "플랫폼",
                         description: "You can add ADD in the app right now"))


        
        // ====================================================================================
        // Calendar Custom
        // Set calendar delegate and dataSource
        calendar.delegate = self
        calendar.dataSource = self
        // ====================================================================================
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 스크롤 가능 여부
//        calendar.scrollEnabled = true
        
        // 헤더 폰트 설정
//        calendar.appearance.headerTitleFont = UIFont(name: "NotoSansKR-Medium", size: 16)

        // Weekday 폰트 설정
//        calendar.appearance.weekdayFont = UIFont(name: "NotoSansKR-Regular", size: 14)

        // 각각의 일(날짜) 폰트 설정 (ex. 1 2 3 4 5 6 ...)
//        calendar.appearance.titleFont = UIFont(name: "NotoSansKR-Regular", size: 14)
        
        // 헤더의 날짜 포맷 설정
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        
        // 헤더의 폰트 색상 설정
        calendar.appearance.headerTitleColor = UIColor.link
        
        // 헤더의 폰트 정렬 설정
        // .center & .left & .justified & .natural & .right
        calendar.appearance.headerTitleAlignment = .center

        // 헤더 높이 설정
        calendar.headerHeight = 45

        // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0   // 0.0 = 안보이게 됩니다.
        
        // 이벤트 표시 색상 변경
        calendar.appearance.eventDefaultColor = UIColor.red
    }
    
    
    // ====================================================================================
    // 캘린더 및 카드 구현
    // ====================================================================================
    
    // 이벤트가 있다면 present
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let hasEvent = numberOfEvents(for: date) > 0
        if hasEvent {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 M월 d일"
            let testEventDate = Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 10))!
            let dateString = dateFormatter.string(from: testEventDate)

            let name = "홍길동" // 유저의 이름
            let count = 24 // count(저장한 ADD 개수)

            let titleString = "\(dateString),\n\(name) 님의 \(count)가지 ADD 기록"

            // card present
            let vc = CardSliderViewController.with(dataSource: self)
            vc.title = titleString
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }


    
    // **이벤트(포토카드가 있는 경우)가 있는 날짜를 저장하는 것을 구현해야 함.**
    func numberOfEvents(for date: Date) -> Int {
        // 이벤트가 있는 날짜에 1을 반환
        // 여기서는 2023년 7월 10일에 이벤트가 있는 것으로 가정하겠습니다.
        let testEventDate = Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 10))!
        if Calendar.current.isDate(date, inSameDayAs: testEventDate) {
            return 1
        }
        return 0
    }

    // 이벤트가 있는 날짜 (numberOfEvents) 에 UIColor 넣기
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let hasEvent = numberOfEvents(for: date) > 0
        return hasEvent ? [appearance.eventDefaultColor] : nil
    }

    // FSCalendarDelegate 메서드 추가
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return numberOfEvents(for: date)
    }
    
    // CardSlider 구현 함수
    func item(for index: Int) -> CardSlider.CardSliderItem {
        return data[index]
    }

    func numberOfItems() -> Int {
        return data.count
    }
    
    fileprivate let imageDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    fileprivate let datesWithImage = ["2023-07-11", "2023-08-05"]

    // 특정 날짜에 이미지 삽입
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let dateString = imageDateFormatter.string(from: date)
        
        if datesWithImage.contains(dateString) {
            let image = UIImage(named: "movie.png")
            let imageSize = CGSize(width: 30, height: 30) // 이미지 크기 조정
            
            if let imageWithAlpha = image?.applyAlpha(0.5) {
                return imageWithAlpha.resize(to: imageSize)
            }
        }
        
        return nil
    }


    // ====================================================================================
    
    
    // Label 구현 함수
    func updateLabel(withName name: String, andCount count: Int) {
        let labelText = "\(name)님은\n\(count)가지 ADD 기록이 있어요."
        let attributedString = NSMutableAttributedString(string: labelText)

        if let nameRange = labelText.range(of: name) {
            let nameNSRange = NSRange(nameRange, in: labelText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: nameNSRange)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: myLabel.font.pointSize), range: nameNSRange)
        }

        if let countRange = labelText.range(of: "\(count)가지 ADD") {
            let countNSRange = NSRange(countRange, in: labelText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: countNSRange)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: myLabel.font.pointSize), range: countNSRange)
        }
        myLabel.attributedText = attributedString
    }

}

extension UIImage {
    func applyAlpha(_ value: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resize(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


