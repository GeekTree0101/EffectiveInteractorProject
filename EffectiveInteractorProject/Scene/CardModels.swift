//
//  CardModels.swift
//  EffectiveInteractorProject
//
//  Created by Hyeon su Ha on 04/11/2019.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation

enum CardModels {
  
  enum RelatedCardPaging {
    
    struct Request {
      
      enum Target {
        case reload
        case loadMore
      }
      
      var target: Target
    }
    
    struct Response {
      
      var cards: [Card]?
      var error: Error?
    }
    
    struct ViewModel {
      
    }
  }
  
  enum FetchCard {
    
    struct Request {
      
    }
    
    struct Response {
      
      var card: Card?
      var error: Error?
    }
    
    struct ViewModel {
      
    }
  }
  
  enum FetchUser {
    
    struct Request {
      
    }
    
    struct Response {
      
      var user: User?
      var error: Error?
    }
    
    struct ViewModel {
      
    }
  }
}
