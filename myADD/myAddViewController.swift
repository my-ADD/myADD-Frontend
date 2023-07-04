//
//  .swift
//  myADD
//
//  Created by 이융의 on 2023/07/04.
//

import UIKit

class myAddViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = "홍길동" // 유저의 이름 변수
        let month = 6
        let day = 9
        let count = 2
        

        
        // 부분 텍스트 구현
        updateLabel(withName: name, andCount: month, andCount: day, andCount: count)
    }
    
    // 부분 텍스트 구현 함수
    func updateLabel(withName name: String, andCount month: Int, andCount day: Int, andCount count: Int) {
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


    //    let logo = UIImage(named: "logo.png")
    //    let imageView = UIImageView(image: logo)
    //    imageView.contentMode = .scaleAspectFit // set imageview's content mode
    //    self.navigationItem.titleView = imageView
