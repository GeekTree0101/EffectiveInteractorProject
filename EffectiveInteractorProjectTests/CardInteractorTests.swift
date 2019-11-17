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
  
  class Stub_CardWorker: CardWorker {
    
    var getCardValue: Promise<Card>!
    var getUserValue: Promise<User>!
    var getRelatedCardsValue: Promise<[Card]>!
    
    override func getCard(id: Int) -> Promise<Card> {
      return getCardValue
    }
    
    override func getUser(id: Int) -> Promise<User> {
      return getUserValue
    }
    
    override func getRelatedCards(nextSince: Int) -> Promise<[Card]> {
      return getRelatedCardsValue
    }
  }
  
  class Spy_CardWorker: CardWorker {
    
    var getCardCalled: Int = 0
    var getUserCalled: Int = 0
    var getRelatedCardsCalled: Int = 0
    
    override func getCard(id: Int) -> Promise<Card> {
      getCardCalled += 1
      return .value(Card.init(id: -1))
    }
    
    override func getUser(id: Int) -> Promise<User> {
      getUserCalled += 1
      return .value(User.init(id: -1))
    }
    
    override func getRelatedCards(nextSince: Int) -> Promise<[Card]> {
      getRelatedCardsCalled += 1
      return .value([])
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
    let worker = Spy_CardWorker()
    
    self.interactor.worker = worker
    
    self.interactor.cardID = nil
    
    // when
    self.interactor.fetchCard(request: CardModels.FetchCard.Request())
    
    // then
    expect(worker.getCardCalled).toEventually(equal(0))
  }
  
  func testFetchCardShouldBeSuccessWithCardID() {
    // given
    let worker = Spy_CardWorker()
    
    self.interactor.worker = worker
    
    self.interactor.cardID = 1
    
    // when
    self.interactor.fetchCard(request: CardModels.FetchCard.Request())
    
    // then
    expect(worker.getCardCalled).toEventually(equal(1))
  }
  
  func testFetchCardShouldBeCalledPresenterOnSuccess() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Stub_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    self.interactor.cardID = 1
    worker.getCardValue = Promise.value(Card.init(id: 1))
    
    
    // when
    self.interactor.fetchCard(request: CardModels.FetchCard.Request())
    
    // then
    expect(presenter.presentFetchCardCalled).toEventually(equal(1))
  }
  
  func testFetchCardShouldBeCalledPresenterOnError() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Stub_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    self.interactor.cardID = 1
    worker.getCardValue = Promise.init(error: NSError.init(domain: "test", code: -1, userInfo: nil))
    
    
    // when
    self.interactor.fetchCard(request: CardModels.FetchCard.Request())
    
    // then
    expect(presenter.presentFetchCardCalled).toEventually(equal(1))
  }
  
  func testFetchCardShouldNotBeCalledPresenterWithoutCardID() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Stub_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    self.interactor.cardID = nil
    
    // when
    self.interactor.fetchCard(request: CardModels.FetchCard.Request())
    
    // then
    expect(presenter.presentFetchCardCalled).toEventually(equal(0))
  }
}

// MARK: - FetchUser

extension CardInteractorTests {
  
  func testFetchUserShouldBeFailedWithoutUserID() {
    // given
    let worker = Spy_CardWorker()
    
    self.interactor.worker = worker
    
    self.interactor.userID = nil
    
    // when
    self.interactor.fetchUser(request: CardModels.FetchUser.Request())
    
    // then
    expect(worker.getUserCalled).toEventually(equal(0))
  }
  
  func testFetchUserShouldBeSuccessWithUserID() {
    // given
    let worker = Spy_CardWorker()
    
    self.interactor.worker = worker
    
    self.interactor.userID = 1
    
    // when
    self.interactor.fetchUser(request: CardModels.FetchUser.Request())
    
    // then
    expect(worker.getUserCalled).toEventually(equal(1))
  }
  
  
  func testFetchUserShouldBeCalledPresenter() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Stub_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    self.interactor.userID = 1
    worker.getUserValue = Promise.value(User.init(id: 1))
    
    // when
    self.interactor.fetchUser(request: CardModels.FetchUser.Request())
    
    // then
    expect(presenter.presentFetchUserCalled).toEventually(equal(1))
  }
  
  func testFetchUserShouldNotBeCalledPresenter() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Stub_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    self.interactor.userID = nil
    worker.getUserValue = Promise.value(User.init(id: 1))
    
    // when
    self.interactor.fetchUser(request: CardModels.FetchUser.Request())
    
    // then
    expect(presenter.presentFetchUserCalled).toEventually(equal(0))
  }
}

// MARK: - Related card pagination

extension CardInteractorTests {
  
  func testFetchRelatedCardShouldBeCalledRelatedCard() {
    // given
    let worker = Spy_CardWorker.init()
    
    self.interactor.worker = worker
    self.interactor.nextSince = nil
    
    // when
    _ = self.interactor.fetchRelatedCard(request: CardModels.RelatedCardPaging.Request(target: .reload))
    
    // then
    expect(worker.getRelatedCardsCalled).toEventually(equal(1))
  }
  
  func testFetchRelatedCardShouldBeCalledRelatedCard2() {
    // given
    let worker = Spy_CardWorker.init()
    
    self.interactor.worker = worker
    self.interactor.nextSince = 100
    
    // when
    _ = self.interactor.fetchRelatedCard(request: CardModels.RelatedCardPaging.Request(target: .loadMore))
    
    // then
    expect(worker.getRelatedCardsCalled).toEventually(equal(1))
  }
  
  func testFetchRelatedCardShouldBeNotCalledRelatedCard() {
    // given
    let worker = Spy_CardWorker.init()
    
    self.interactor.worker = worker
    self.interactor.nextSince = nil
    
    // when
    _ = self.interactor.fetchRelatedCard(request: CardModels.RelatedCardPaging.Request(target: .loadMore))
    
    // then
    expect(worker.getRelatedCardsCalled).toEventually(equal(0))
  }
  
  
  func testFetchRelatedCardShouldBeCalledPresenterOnSuccessToReload() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Stub_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    worker.getRelatedCardsValue = Promise.value([Card.init(id: 1)])
    
    // when
    let hasNext = self.interactor.fetchRelatedCard(request: CardModels.RelatedCardPaging.Request(target: .reload))
    
    // then
    expect(presenter.presentFetchRelatedCardCalled).toEventually(equal(1))
    expect(try? hang(hasNext)) == true
  }
  
  func testFetchRelatedCardShouldBeCalledPresenterOnSuccessToLoadMore() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Stub_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    self.interactor.nextSince = 100
    
    worker.getRelatedCardsValue = Promise.value([Card.init(id: 101)])
    
    // when
    let hasNext = self.interactor.fetchRelatedCard(request: CardModels.RelatedCardPaging.Request(target: .loadMore))
    
    // then
    expect(presenter.presentFetchRelatedCardCalled).toEventually(equal(1))
    expect(try? hang(hasNext)) == true
  }
  
  func testFetchRelatedCardShouldBeCalledPresenterOnEndedPaging() {
    // given
    let presenter = Spy_CardPresenter()
    let worker = Stub_CardWorker()
    
    self.interactor.presenter = presenter
    self.interactor.worker = worker
    
    worker.getRelatedCardsValue = Promise.value([Card.init(id: 101)])
    
    // when
    let hasNext = self.interactor.fetchRelatedCard(request: CardModels.RelatedCardPaging.Request(target: .loadMore))
    
    // then
    expect(presenter.presentFetchRelatedCardCalled).toEventually(equal(0))
    expect(try? hang(hasNext)) == false
  }
  
}
