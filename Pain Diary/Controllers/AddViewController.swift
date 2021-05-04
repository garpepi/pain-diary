//
//  AddViewController.swift
//  Pain Diary
//
//  Created by Garpepi Aotearoa on 05/05/21.
//

import UIKit

class AddViewController: UIViewController, UITextViewDelegate {

  @IBOutlet weak var Front: UILabel!
  @IBOutlet weak var Back: UILabel!
  @IBOutlet weak var DateLabel: UILabel!
  @IBOutlet weak var Descriptions: UITextView!


  var date:Date = Date()
  var front:Int = 0
  var back:Int = 0
  var descriptions:String = ""
  var flag:Bool = false
  var painPoints:[painPoint] = []

  override func viewDidLoad() {
        super.viewDidLoad()

    //  setup
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
        DateLabel.text = dateFormatter.string(from: date)
        Back.text = String(back)
        Front.text = String(front)

        Descriptions.textColor = UIColor.lightGray
        Descriptions.text = "Ex: My head feel soo heavy. Last 2 hour i just ate an expired salmon."
        Descriptions.delegate = self
    }

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
            textView.text = "Ex: My head feel soo heavy. Last 2 hour i just ate an expired salmon."
            textView.textColor = UIColor.lightGray
        }
  }
  
  @IBAction func cancelButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

  @IBAction func saveButtonClicked(_ sender: Any) {
    var doInsert:ModelResponseDefault

    doInsert = HistoryModel().insertAll(notes: Descriptions.text, date: date, painPoints: painPoints, back: back, front: front)

    print(doInsert)
  }
  
}


