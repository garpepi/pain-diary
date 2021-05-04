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
  @IBOutlet weak var TouchArea: UIView!

  @IBOutlet weak var PainMeasurement: UISlider!
  @IBOutlet weak var PainMeasurmentNumber: UILabel!

  struct targetPainPoint{
    var x:CGFloat
    var y:CGFloat
    var painPointMeasurement:Int
    var tag:Int
    var direction:String
  }
  
  var seletedTarget:UIView = UIView()
  var targetPoints:[Int:targetPainPoint] = [:]
  var targetIndex:Int = 0
  let colorPainMeasurement:[UIColor] = [#colorLiteral(red: 0.1921568627, green: 0.7058823529, blue: 0.3882352941, alpha: 1),#colorLiteral(red: 0.3843137255, green: 0.7254901961, blue: 0.3019607843, alpha: 1),#colorLiteral(red: 0.5411764706, green: 0.7411764706, blue: 0.2117647059, alpha: 1),#colorLiteral(red: 0.6941176471, green: 0.7450980392, blue: 0.1137254902, alpha: 1),#colorLiteral(red: 0.8470588235, green: 0.7411764706, blue: 0.01568627451, alpha: 1),#colorLiteral(red: 1, green: 0.7215686275, blue: 0.04705882353, alpha: 1),#colorLiteral(red: 0.968627451, green: 0.6078431373, blue: 0, alpha: 1),#colorLiteral(red: 0.9333333333, green: 0.4941176471, blue: 0, alpha: 1),#colorLiteral(red: 0.8862745098, green: 0.3725490196, blue: 0.003921568627, alpha: 1),#colorLiteral(red: 0.8274509804, green: 0.2431372549, blue: 0.04705882353, alpha: 1),#colorLiteral(red: 0.7647058824, green: 0.05490196078, blue: 0.07843137255, alpha: 1)]


  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      self.initView()
      self.BodyPath.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappingHandler)))
      self.TrashTarget.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(trashTarget)))

      // Hidden element control
      hiddenElement()

      self.PainMeasurement.value = 0
      self.PainMeasurement.setThumbImage(#imageLiteral(resourceName: "WB1"), for: .normal)
      self.PainMeasurement.isHidden = true
    }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToAddPage" {
        if let nextViewController = segue.destination as? AddViewController {
          print(targetPoints)
          // parse Parameter
          // parse point
          var front:Int = 0
          var back:Int = 0

          for point in targetPoints {
            if(point.value.direction == "Front"){
              front += 1
            }else{
              back += 1
            }
            let tempPoint: painPoint = painPoint(x: Double(point.value.x), y: Double(point.value.y), painScale: point.value.painPointMeasurement, direction: point.value.direction)
            nextViewController.painPoints.append(tempPoint)
          }

          // parse header info
          nextViewController.front = front
          nextViewController.back = back
        }
    }
  }

  @IBAction func saveButtonClicked(_ sender: Any) {
    performSegue(withIdentifier: "goToAddPage", sender: self)
  }
  func initView(){
    self.ClearButton.layer.cornerRadius = 8
    self.SaveButton.layer.cornerRadius = 8
  }

  func hiddenElement(){
    if self.TouchArea.subviews.count > 1 {
      self.ClearButton.isHidden = false
      self.SaveButton.isHidden = false
      self.TrashTarget.isHidden = false
    }else{
      self.ClearButton.isHidden = true
      self.SaveButton.isHidden = true
      self.TrashTarget.isHidden = true
    }
  }

  @IBAction func directionChange(_ sender: Any) {
    print("change")
    if self.BodyDirection.selectedSegmentIndex == 0{
      hideTarget(tagsmin: 2000,tagsmax: 3000)
    }else{
      hideTarget(tagsmin: 1000,tagsmax: 2000)
    }
    showTarget(direction: self.BodyDirection.selectedSegmentIndex)
  }

  func hideTarget(tagsmin:Int, tagsmax:Int){

    if(self.TouchArea.subviews.count > 1)
    {
      var index = 0
      for subUIView in self.TouchArea.subviews as [UIView] {
        if index == 0{
          index = 1
          continue
        }else{
          print("\(subUIView.tag) ==> \(subUIView.tag > tagsmin && subUIView.tag < tagsmax)")
          if(subUIView.tag > tagsmin && subUIView.tag < tagsmax){
            subUIView.isHidden = true
          }else{
            continue
          }
        }
      }
    }
  }

  func showTarget(direction:Int){
    if self.TouchArea.subviews.count > 1{
      var index = 0
      if direction == 0{
        for subUIView in self.TouchArea.subviews as [UIView] {
          if index == 0{
            index = 1
            continue
          }else{
            if(subUIView.tag > 1000 && subUIView.tag < 2000){
              subUIView.isHidden = false
            }else{
              continue
            }
          }
        }
      }else{
        for subUIView in self.TouchArea.subviews as [UIView] {
          if index == 0{
            index = 1
            continue
          }else{
            if(subUIView.tag > 2000 && subUIView.tag < 3000){
              subUIView.isHidden = false
            }else{
              continue
            }
          }
        }
      }
    }

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

    // Tag the UIView
    let tagIndex = targetTagging()
    painPoint.tag = tagIndex

    // Assign Value

    if self.BodyDirection.selectedSegmentIndex == 0{
      targetPoints[tagIndex] = targetPainPoint.init(x: x, y: y, painPointMeasurement: 0, tag: tagIndex, direction: "Front")
    }else{
      targetPoints[tagIndex] = targetPainPoint.init(x: x, y: y, painPointMeasurement: 0, tag: tagIndex, direction: "Back")
    }

    // UI Control
    borderSelected(gestureView: painPoint)
    // Hidden element control
    hiddenElement()
    sliderControl()
  }

  func sliderControl(painValue: Float = 0.0){
    self.PainMeasurement.isHidden = false
    self.PainMeasurement.value = painValue
    setupSlider(painValue: Int(painValue))
  }

  func setupSlider(painValue: Int){
    switch painValue {
      case 0...1:
        self.PainMeasurement.setThumbImage(#imageLiteral(resourceName: "WB1"), for: .normal)
      case 2...3:
        self.PainMeasurement.setThumbImage(#imageLiteral(resourceName: "WB2"), for: .normal)
      case 4...5:
        self.PainMeasurement.setThumbImage(#imageLiteral(resourceName: "WB3"), for: .normal)
      case 6...8:
        self.PainMeasurement.setThumbImage(#imageLiteral(resourceName: "WB4"), for: .normal)
      case 9...10:
        self.PainMeasurement.setThumbImage(#imageLiteral(resourceName: "WB5"), for: .normal)
    default:
      self.PainMeasurement.setThumbImage(#imageLiteral(resourceName: "WB1"), for: .normal)
    }
    self.PainMeasurmentNumber.text = String(painValue)
  }

  func targetTagging()-> Int{
    targetIndex+=1
    if self.BodyDirection.selectedSegmentIndex == 0{
      return 1000 + targetIndex
    }else{
      return 2000 + targetIndex
    }
  }

  @IBAction func PainMeasurementOnChange(_ sender: Any) {
    if !self.seletedTarget.frame.isEmpty{
      // get value
      let value = Int(self.PainMeasurement.value)

      // set slider
      self.PainMeasurmentNumber.text = String(value)
      self.setupSlider(painValue: value)
      self.targetPoints[self.seletedTarget.tag]?.painPointMeasurement = value

      // set selected
      self.seletedTarget.tintColor = self.colorPainMeasurement[value]
    }

  }


  @IBAction func ClearTarget(_ sender: Any) {
    if(self.TouchArea.subviews.count > 1)
    {
      var index = 0
      for subUIView in self.TouchArea.subviews as [UIView] {
        if index == 0{
          index = 1
          continue
        }else{
          subUIView.removeFromSuperview()
        }
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
    self.PainMeasurement.isHidden = false

    //Set Value
    let tags = self.seletedTarget.tag
    if let painScale = targetPoints[tags]?.painPointMeasurement{
      sliderControl(painValue: Float(painScale))
    }


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

      // Update the data

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
