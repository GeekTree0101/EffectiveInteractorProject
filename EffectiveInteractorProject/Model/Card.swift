//
//  Card.swift
//  EffectiveInteractorProject
//
//  Created by Geektree0101 on 04/11/2019.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation
import Codextended

struct Card: Decodable {
  
  var id: Int
  var title: String?
  var content: String?
  
  init(from decoder: Decoder) throws {
    
    id = try! decoder.decode("id")
    title = try? decoder.decode("title")
    content = try? decoder.decode("content")
  }
}
