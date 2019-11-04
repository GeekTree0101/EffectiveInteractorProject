//
//  CardWorker.swift
//  EffectiveInteractorProject
//
//  Created by Hyeon su Ha on 04/11/2019.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation
import PromiseKit
import Codextended

class CardWorker {
  
  public func getCard(id: Int) -> Promise<Card> {
    
    return Promise<Card> { seal in
      let dummyJSON: [String: Any] = [
        "id": 1,
        "title": "this is card",
        "content": "hello world"
      ]
      
      let dummyData: Data = try! JSONSerialization.data(
        withJSONObject: dummyJSON,
        options: .prettyPrinted
      )
      
      guard let card = try? dummyData.decoded() as Card else {
        seal.reject(NSError.init(domain: "not found", code: 200, userInfo: nil))
        return
      }
      
      seal.fulfill(card)
    }
  }
  
  public func getUser(id: Int) -> Promise<User> {
    
    return Promise<User> { seal in
      
      let dummyJSON: [String: Any] = [
        "id": 100,
        "username": "Geektree0101"
      ]
      
      let dummyData: Data = try! JSONSerialization.data(
        withJSONObject: dummyJSON,
        options: .prettyPrinted
      )
      
      guard let user = try? dummyData.decoded() as User else {
        seal.reject(NSError.init(domain: "not found", code: 200, userInfo: nil))
        return
      }
      
      seal.fulfill(user)
    }
  }
}
