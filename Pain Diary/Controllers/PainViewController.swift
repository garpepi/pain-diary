//
//  PainViewController.swift
//  Pain Diary
//
//  Created by Garpepi Aotearoa on 01/05/21.
//

import UIKit

class PainViewController: UIViewController {

  @IBOutlet weak var ClearButton: UIButton!
  @IBOutlet weak var SaveButton: UIButton!
  @IBOutlet weak var BodyPath: UIImageView!
  @IBOutlet weak var BodyDirection: UISegmentedControl!
  @IBOutlet weak var TrashTarget: UIImageView!
  @IBOutlet weak var PainMeasurement: UISlider!
  @IBOutlet weak var TouchArea: UIView!
  
  var seletedTarget:UIView = UIView()

  var frontPoint:[UIView] = []
  var backPoint:[UIView] = []


  override func viewDidLoad() {
      super.viewDidLoad()

        // Do any additional setup after loading the view.
      self.initView()
      self.BodyPath.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappingHandler)))
      self.TrashTarget.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(trashTarget)))
    }
    
  func initView(){
    self.ClearButton.layer.cornerRadius = 8
    self.SaveButton.layer.cornerRadius = 8
  }

  @objc func trashTarget(gesture: UITapGestureRecognizer){
    if(self.seletedTarget.frame.isEmpty){
      return
    }

    self.seletedTarget.removeFromSuperview()
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
    self.TouchArea.addSubview(painPoint)
    self.TouchArea.bringSubviewToFront(painPoint)

    // Adding Gesture on new UIView (painpoint)
    painPoint.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panningHandler))) // for dragging
    painPoint.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTapHandler))) // for selecting

    frontPoint.append(painPoint)
    // Tag the UIView
    painPoint.tag = 15
    borderSelected(gestureView: painPoint)
  }

  @IBAction func ClearTarget(_ sender: Any) {
    if let foundView = self.TouchArea.viewWithTag(15) {
        foundView.removeFromSuperview()
    }

    for subUIView in self.TouchArea.subviews as [UIView] {
      if let foundView = subUIView.viewWithTag(15) {
          foundView.removeFromSuperview()
      }
    }

  }

  @objc func tappingHandler(gesture: UITapGestureRecognizer){
    let coordinate = gesture.location(in: self.TouchArea)
    createPainPoin(x: coordinate.x - 16 , y: coordinate.y - 16)
    //print(BodyPath.getColourFromPoint(point: coordinate))
  }

  @objc func selectedTapHandler(gesture: UITapGestureRecognizer){
    // set border
    // MARK ASK
    borderSelected(gestureView: gesture.view!)
  }

  func borderSelected(gestureView: UIView){
    if(!self.seletedTarget.frame.isEmpty){
      self.seletedTarget.layer.borderWidth = 0
    }

    self.seletedTarget = gestureView
    if(!gestureView.frame.isEmpty){
      gestureView.layer.borderWidth = 1
      gestureView.layer.borderColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
    }

  }

  @objc func panningHandler(gesture: UIPanGestureRecognizer){
      borderSelected(gestureView: gesture.view!)
      let location = gesture.location(in: self.TouchArea)
      if((location.x > 0) && (location.x < self.TouchArea.frame.width) && (location.y > 0) && (location.y < self.TouchArea.frame.height)){
        let draggedView = gesture.view
        draggedView?.center = location
        //print(self.BodyPath.layer.colorOfPoint(point: location))
      }
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

        let color = UIColor(red:red, green: green, blue:blue, alpha:alpha)

        return color
    }
}
