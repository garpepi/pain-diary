//
//  PointDataModel.swift
//  Pain Diary
//
//  Created by Garpepi Aotearoa on 05/05/21.
//

import Foundation

struct painPoint {
  var x:Double
  var y:Double
  var painScale:Int
  var direction:String

  init(x:Double, y:Double, painScale:Int, direction:String){
    self.x = x
    self.y = y
    self.painScale = painScale
    self.direction = direction
  }
}
