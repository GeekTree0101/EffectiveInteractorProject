//
//  EffectiveInteractorProjectTests.swift
//  EffectiveInteractorProjectTests
//
//  Created by Geektree0101 on 04/11/2019.
//  Copyright © 2019 Geektree0101. All rights reserved.
//

import XCTest
import Nimble

import PromiseKit

@testable import EffectiveInteractorProject

class CardInteractorTests: XCTestCase {
  
  // MARK: - Test Double
  
  class Spy_CardPresenter: CardPresenterLogic {
    
    var presentFetchCardCalled: Int = 0
    var presentFetchUserCalled: Int = 0
    var presentFetchRelatedCardCalled: Int = 0
    
    func presentFetchCard(response: CardModels.FetchCard.Response) {
      presentFetchCardCalled += 1
    }
    
    func presentFetchUser(response: CardModels.FetchUser.Response) {
      presentFetchUserCalled += 1
    }

    func presentFetchRelatedCard(response: CardModels.RelatedCardPaging.Response) {
      presentFetchRelatedCardCalled += 1
    }
  }
  
  class Spy_CardWorker: CardWorker {
    
    var getCardCalled: Int = 0
    var getUserCalled: Int = 0
    
    override func getCard(id: Int) -> Promise<Card> {
      getCardCalled += 1
      return .value(Card.init(id: -1))
    }
    
    override func getUser(id: Int) -> Promise<User> {
      getUserCalled += 1
      return .value(User.init(id: -1))
    }
    
  }
  
  // MARK: - Props
  var interactor: CardInteractor!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.interactor = CardInteractor.init()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
}

// MARK: - FetchCard

extension CardInteractorTests {
  
  func testFetchCardShouldBeFailedWithoutCardID() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Spy_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    self.interactor.cardID = nil
    
    // when
    self.interactor.fetchCard(request: CardModels.FetchCard.Request())
    
    // then
    expect(worker.getCardCalled).toEventually(equal(0))
    expect(presenter.presentFetchCardCalled).toEventually(equal(0))
  }
  
  func testFetchCardShouldBeSuccessWithCardID() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Spy_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    self.interactor.cardID = 1
    
    // when
    self.interactor.fetchCard(request: CardModels.FetchCard.Request())
    
    // then
    expect(worker.getCardCalled).toEventually(equal(1))
    expect(presenter.presentFetchCardCalled).toEventually(equal(1))
  }
}

// MARK: - FetchUser

extension CardInteractorTests {
  
  func testFetchUserShouldBeFailedWithoutUserID() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Spy_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    self.interactor.userID = nil
    
    // when
    self.interactor.fetchUser(request: CardModels.FetchUser.Request())
    
    // then
    expect(worker.getUserCalled).toEventually(equal(0))
    expect(presenter.presentFetchUserCalled).toEventually(equal(0))
  }
  
  func testFetchUserShouldBeSuccessWithUserID() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Spy_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    self.interactor.userID = 1
    
    // when
    self.interactor.fetchUser(request: CardModels.FetchUser.Request())
    
    // then
    expect(worker.getUserCalled).toEventually(equal(1))
    expect(presenter.presentFetchUserCalled).toEventually(equal(1))
  }
}

// MARK: - Related card pagination

extension CardInteractorTests {
  
  func testFetchCardShouldBeSuccessToReload() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Spy_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    // when
    let hasNext = self.interactor.fetchRelatedCard(request: CardModels.RelatedCardPaging.Request(target: .reload))
    
    // then
    expect(presenter.presentFetchRelatedCardCalled).toEventually(equal(1))
    expect(try? hang(hasNext)) == true
  }
  
  func testFetchCardShouldBeSuccessToLoadMore() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Spy_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    self.interactor.nextSince = 100
    
    // when
    let hasNext = self.interactor.fetchRelatedCard(request: CardModels.RelatedCardPaging.Request(target: .loadMore))
    
    // then
    expect(presenter.presentFetchRelatedCardCalled).toEventually(equal(1))
    expect(try? hang(hasNext)) == true
  }
  
  func testFetchCardShouldBeEndedPaging() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Spy_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    // when
    let hasNext = self.interactor.fetchRelatedCard(request: CardModels.RelatedCardPaging.Request(target: .loadMore))
    
    // then
    expect(presenter.presentFetchRelatedCardCalled).toEventually(equal(0))
    expect(try? hang(hasNext)) == false
  }
  
}
