//
//  HistoryModel.swift
//  Pain Diary
//
//  Created by Garpepi Aotearoa on 04/05/21.
//

import UIKit
import CoreData

class HistoryModel{
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  func insertAll(notes: String, flag: Bool = false, date: Date, painPoints:[painPoint], back:Int, front:Int ) -> ModelResponseDefault {
    var response : ModelResponseDefault

    // create hstory
    let history = History(context: context)
    history.back = Int16(back)
    history.front = Int16(front)
    history.date = date
    history.notes = notes
    history.flag = false

    // create group of point
    for painPoin in painPoints{
      let point = PainPointLocation(context: context)
      point.direction = painPoin.direction
      point.painScale = Int16(painPoin.painScale)
      point.x = painPoin.x
      point.y = painPoin.y
      history.addToPainPointLocations(point)
    }

    // save
    do{
      try context.save()
      response = ModelResponseDefault(query_status: true, message: "OK", data: history)
    } catch {
      response = ModelResponseDefault(query_status: false, message: "Error: \(error)", data: nil)
    }

    return response
  }

  func getHistory(direction: String =  "All") -> ModelResponseDefault
  {
    var response : ModelResponseDefault

    var history: [History]
    let request : NSFetchRequest<History> = History.fetchRequest()

    do{
      history = try context.fetch(request)
      response = ModelResponseDefault(query_status: true, message: "OK", data: history)
    } catch {
      response = ModelResponseDefault(query_status: false, message: "Error: \(error)", data: nil)
    }

    return response

  }
}


