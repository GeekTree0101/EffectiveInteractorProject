//
//  User.swift
//  EffectiveInteractorProject
//
//  Created by Geektree0101 on 04/11/2019.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation
import Codextended

struct User: Decodable {
  
  var id: Int
  var username: String?
  
  init(from decoder: Decoder) throws {
    
    id = try! decoder.decode("id")
    username = try? decoder.decode("username")
  }
  
}
