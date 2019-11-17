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
  
  public func getRelatedCards(nextSince: Int) -> Promise<[Card]> {
    
    return Promise<[Card]> { seal in
      seal.fulfill([
        Card.init(id: nextSince + 1),
        Card.init(id: nextSince + 2),
        Card.init(id: nextSince + 3)
      ])
    }
  }
  
  public func getCard(id: Int) -> Promise<Card> {
    
    return Promise<Card> { seal in
      seal.fulfill(Card.init(id: 1))
    }
  }
  
  public func getUser(id: Int) -> Promise<User> {
    
    return Promise<User> { seal in
      seal.fulfill(User.init(id: 1))
    }
  }
}
