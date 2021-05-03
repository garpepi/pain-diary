//
//  PainViewController.swift
//  Pain Diary
//
//  Created by Garpepi Aotearoa on 01/05/21.
//

import UIKit

class PainViewController: UIViewController {

  @IBOutlet weak var tempPoint: UIView!
  @IBOutlet weak var ClearButton: UIButton!
  @IBOutlet weak var SaveButton: UIButton!
  @IBOutlet weak var BodyPath: UIImageView!
  @IBOutlet weak var BodyDirection: UISegmentedControl!

  @IBOutlet weak var locationCoor: UILabel!
  @IBOutlet weak var colorTap: UILabel!

  @IBOutlet weak var colorlocation: UILabel!

  var frontPoint:[UIView] = []
  var backPoint:[UIView] = []

  override func viewDidLoad() {
      super.viewDidLoad()

        // Do any additional setup after loading the view.
      self.initView()

    // TEST
    print(BodyPath.layer.zPosition)
    // EN DTEST
      self.BodyPath.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappingHandler)))

      self.tempPoint.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panningHandler)))
    }
    
  func initView(){
    self.ClearButton.layer.cornerRadius = 8
    self.SaveButton.layer.cornerRadius = 8
  }

  func tagIndex()-> Int{
    if BodyDirection.selectedSegmentIndex == 0{
      return self.frontPoint.count
    }
    else{
      return self.backPoint.count
    }
  }

  func createPainPoin(x: CGFloat, y:CGFloat){

    // Setting for painpoint UIView
    let painPoint = UIView(frame: CGRect(x: x, y: y, width: 32, height: 32))
    let painPointImage = UIImage(systemName: "target")
    let painPointImageView = UIImageView(image: painPointImage)
    painPointImageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    painPoint.addSubview(painPointImageView)
    painPoint.bringSubviewToFront(painPointImageView)
    painPoint.tintColor = #colorLiteral(red: 0, green: 0.4176123142, blue: 0.6501051784, alpha: 1)

    // Put it in view
    self.view.addSubview(painPoint)
    self.view.bringSubviewToFront(painPoint)

    // Adding Gesture on new UIView (painpoint)
    painPoint.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panningHandler))) // for dragging
    painPoint.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTapHandler))) // for selecting

    frontPoint.append(painPoint)
    print(frontPoint)
    // Tag the UIView
    painPoint.tag = tagIndex()

  }


  @objc func tappingHandler(gesture: UITapGestureRecognizer){
    print("CN tapped!")
    let coordinate = gesture.location(in: self.view)
    createPainPoin(x: coordinate.x - 16 , y: coordinate.y - 16)
    //print(BodyPath.getColourFromPoint(point: coordinate))
  }

  @objc func selectedTapHandler(gesture: UITapGestureRecognizer){
    print("selected tapped!")
    print(gesture.view)
  }

  @objc func panningHandler(gesture: UIPanGestureRecognizer){
    //print(gesture)
     // print(gesture.location(in: self.view))
      let location = gesture.location(in: self.view)
      //print("BodyPath : \(BodyPath.getColourFromPoint(point: location))")
      let draggedView = gesture.view
      draggedView?.center = location
    // get x - y location of image
    print("\(BodyPath.frame.origin.x) vs \(BodyPath.bounds.origin.x) ==> \(location.x + BodyPath.frame.origin.x)")
    print("\(BodyPath.frame.origin.y) vs \(BodyPath.bounds.origin.y) ==> \(location.y + BodyPath.frame.origin.y)")
    print(BodyPath.layer.colorOfPoint(point: CGPoint(x: location.x - BodyPath.frame.origin.x, y: location.y - BodyPath.frame.origin.y)))

  }

}

extension CALayer {

    func colorOfPoint(point:CGPoint) -> UIColor
    {
        var pixel:[CUnsignedChar] = [0,0,0,0]

        let colorSpace = CGColorSpaceCreateDeviceRGB()
      let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

      let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace,bitmapInfo: bitmapInfo.rawValue)

      context!.translateBy(x: -point.x, y: -point.y)

      self.render(in: context!)

        let red:CGFloat = CGFloat(pixel[0])/255.0
        let green:CGFloat = CGFloat(pixel[1])/255.0
        let blue:CGFloat = CGFloat(pixel[2])/255.0
        let alpha:CGFloat = CGFloat(pixel[3])/255.0

        //println("point color - red:\(red) green:\(green) blue:\(blue)")

        let color = UIColor(red:red, green: green, blue:blue, alpha:alpha)

        return color
    }
}
