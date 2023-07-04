import UIKit
import CardSlider

struct Item: CardSliderItem {
    var image: UIImage
    
    var rating: Int?
    
    var title: String
    
    var subtitle: String?
    
    var description: String?
    
}

class ViewController: UIViewController, CardSliderDataSource {
    

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet var myButton: UIButton!
    
    var data = [Item]()
//    var presentText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = "홍길동" // 유저의 이름 변수
        let count = 24 // count 값 변수
//        let present_month = 6
//        let present_day = 9
//        let present_count = 2
        
        
//        presentLabel(withName: name, andCount: present_month, andCount: present_day, andCount: count)
        updateLabel(withName: name, andCount: count)
        
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
    
    
        // 카드 구현
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
    }

    
    @IBAction func didTapButton() {
        // present the cardSlider
        let vc = CardSliderViewController.with(dataSource: self)
//        vc.title = presentText
        vc.title = "Welcome!"
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    // CardSlider 구현 함수
    func item(for index: Int) -> CardSlider.CardSliderItem {
        return data[index]
    }
    func numberOfItems() -> Int {
        return data.count
    }
    
    
    
    
    
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
    
    
    
    
    func presentLabel(withName name: String, andCount month: Int, andCount day: Int, andCount count: Int) {
        let labelText = "\(month)월 \(day)일,\n\(name)님의 \(count)가지 ADD 기록"
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

