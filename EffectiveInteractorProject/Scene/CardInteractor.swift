//
//  CardInteractor.swift
//  EffectiveInteractorProject
//
//  Created by Geektree0101 on 04/11/2019.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import Foundation
import PromiseKit

protocol CardDataStore: class {
  
  var cardID: Int? { get set }
  var userID: Int? { get set }
  var card: Card? { get set }
  var user: User? { get set }
}

protocol CardInteractorLogic: class {
  
  func fetchCard(request: CardModels.FetchCard.Request)
  func fetchUser(request: CardModels.FetchUser.Request)
  func fetchRelatedCard(request: CardModels.RelatedCardPaging.Request) -> Promise<Bool>
}

class CardInteractor: CardDataStore {
  
  // MARK: - DataStore
  var cardID: Int?
  var userID: Int?
  var card: Card?
  var user: User?
  
  // MARK: - Private Props
  var relatedCards: [Card]?
  var nextSince: Int?
  
  public var worker: CardWorker = CardWorker.init()
  public var presenter: CardPresenterLogic?
}

extension CardInteractor: CardInteractorLogic {
  
  func fetchCard(request: CardModels.FetchCard.Request) {
    
    guard let id = cardID else { return }
    worker.getCard(id: id)
      .done(on: .main, { card in
        self.card = card
        self.presenter?.presentFetchCard(
          response: CardModels.FetchCard.Response(card: card)
        )
      })
      .catch(on: .main, { error in
        self.presenter?.presentFetchCard(
          response: CardModels.FetchCard.Response(error: error)
        )
      })
  }
  
  func fetchUser(request: CardModels.FetchUser.Request) {
    
    guard let id = userID else { return }
    worker.getUser(id: id)
      .done(on: .main, { user in
        self.user = user
        self.presenter?.presentFetchUser(
          response: CardModels.FetchUser.Response(user: user)
        )
      })
      .catch(on: .main, { error in
        self.presenter?.presentFetchUser(
          response: CardModels.FetchUser.Response(error: error)
        )
      })
  }
  
  func fetchRelatedCard(request: CardModels.RelatedCardPaging.Request) -> Promise<Bool> {
    
    let fetchRelatedCardWorkflow: Promise<[Card]>
    
    switch request.target {
    case .reload:
      fetchRelatedCardWorkflow = worker.getRelatedCards(nextSince: 0)
    case .loadMore:
      guard let nextSince = self.nextSince else {
        return .value(false)
      }
      fetchRelatedCardWorkflow = worker.getRelatedCards(nextSince: nextSince)
    }
    
    return fetchRelatedCardWorkflow
      .then(on: .main, { cards -> Promise<Bool> in
        self.nextSince = cards.last?.id
        
        switch request.target {
        case .reload:
          self.relatedCards = cards
        case .loadMore:
          self.relatedCards = self.relatedCards ?? [] + cards
        }
        
        self.presenter?.presentFetchRelatedCard(
          response: CardModels.RelatedCardPaging.Response(
            cards: self.relatedCards,
            error: nil
          )
        )
        return .value(self.nextSince != nil)
      })
      .recover(on: .main, { error -> Promise<Bool> in
        
        self.presenter?.presentFetchRelatedCard(
          response: CardModels.RelatedCardPaging.Response(
            cards: self.relatedCards,
            error: error
          )
        )
        return .value(self.nextSince != nil)
      })
  }
}
