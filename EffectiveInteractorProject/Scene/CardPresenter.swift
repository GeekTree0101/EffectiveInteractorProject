//
//  CardPresenter.swift
//  EffectiveInteractorProject
//
//  Created by Hyeon su Ha on 04/11/2019.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation

protocol CardPresenterLogic: class {
  
  func presentFetchCard(response: CardModels.FetchCard.Response)
  func presentFetchUser(response: CardModels.FetchUser.Response)
  func presentFetchRelatedCard(response: CardModels.RelatedCardPaging.Response)
}

class CardPresenter: CardPresenterLogic {
  
  func presentFetchCard(response: CardModels.FetchCard.Response) {
    
  }
  
  func presentFetchUser(response: CardModels.FetchUser.Response) {
     
  }
  
  func presentFetchRelatedCard(response: CardModels.RelatedCardPaging.Response) {
    
  }
}
