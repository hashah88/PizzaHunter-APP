/// Copyright (c) 2017 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

@objc protocol RestaurantListTableViewHeaderDelegate {
  func didTapHeaderButton(_ headerView: RestaurantListTableViewHeader)
}

class RestaurantListTableViewHeader: UIView {
  @IBOutlet var view: UIView!
  @IBOutlet weak var locationButton: UIButton!

  var location: String? {
    didSet {
      locationButton.setTitle(location, for: .normal)
    }
  }

  weak var delegate: RestaurantListTableViewHeaderDelegate?

  init() {
    super.init(frame: CGRect())
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    view = Bundle.main.loadNibNamed("RestaurantListTableViewHeader", owner: self, options: nil)?.first as! UIView
    view.frame = bounds
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 1
    layer.masksToBounds = false
    addSubview(view)
  }

  @IBAction func changeButtonTapped(_ sender: Any) {
    delegate?.didTapHeaderButton(self)
  }
}
