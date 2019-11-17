<img src="https://github.com/GeekTree0101/EffectiveInteractorProject/blob/master/res/preview1.png" />

# Ready to Test Driven Development

## STEP 1: Make an UseCase Models
Design a use case base model for the scene. 
Even if some DTO(Data Transfer Object) don't have any properties, you'll be mindful of extensibility.
```swift
enum CardModels {
  
  enum FetchCard {  // Fetch Card UseCase
    
    // Request DTO(Data Transfer Object)
    // from controller to interactor
    struct Request {
    
    }
    
    // Response DTO(Data Transfer Object)
    // from interactor to presenter
    struct Response {
      
      var card: Card?
      var error: Error?
    }
    
    // Response DTO(Data Transfer Object)
    // from presenter to controller or view
    struct ViewModel {
      
    }
  }
```

## STEP 2: DataStore 
Stores the models commonly used on the scene. also you can pass stored data to other scene
```swift

protocol CardDataStore: class {
  
  var cardID: Int? { get set }
  var card: Card? { get set }
}
```

## STEP 3: Interactor Logic
```swift

protocol CardDataStore: class {
  
  var cardID: Int? { get set }
  var card: Card? { get set }
}

protocol CardInteractorLogic: class {
  
  func fetchCard(request: CardModels.FetchCard.Request)
}
```

## STEP 4: Worker
For some reason I use PromiseKit instead of RxSwift.
- Almost of RESTFul service != event stream. (exception: periodic pooling)
- In CleanSwift Case, interactor doesn't needs disposeBag
- Easy to see and predictable such as logic flow, threading and so on.
```swift
import PromiseKit

class CardWorker {

  public func getCard(id: Int) -> Promise<Card> {
    
    return Promise<Card> { seal in
      seal.fulfill(Card.init(id: 1))
    }
  }
}
```

## STEP 5: Interactor Implementation
```swift

class CardInteractor: CardDataStore {
  
  // MARK: - DataStore
  var cardID: Int?
  var card: Card?
  
  public var worker: CardWorker = CardWorker.init()
}

extension CardInteractor: CardInteractorLogic {
  
  func fetchCard(request: CardModels.FetchCard.Request) {
    
  }
}
```

# Let's start testing

## STEP 1: Interactor Test File
Test target is Interactor. You just put interactor initialization logic into setUp:
```swift

import XCTest
import Nimble

import PromiseKit

@testable import EffectiveInteractorProject

class CardInteractorTests: XCTestCase {

  // MARK: - Props
  var interactor: CardInteractor!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.interactor = CardInteractor.init()
  }

}
```

## STEP 2: Spy Worker
Before designing spy worker, you need to understand Test Double first.
[What is Test double](https://en.wikipedia.org/wiki/Test_double)
```swift

import XCTest
import Nimble

import PromiseKit

@testable import EffectiveInteractorProject

class CardInteractorTests: XCTestCase {

  // Spy Worker
  class Spy_CardWorker: CardWorker {
    
    var getCardCalled: Int = 0
    
    override func getCard(id: Int) -> Promise<Card> {
      getCardCalled += 1
      return .value(Card.init(id: -1))
    }
  }
  
  // MARK: - Props
  var interactor: CardInteractor!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.interactor = CardInteractor.init()
  }

}
```
you can design ```getCardCalled``` property as Boolean. 
In Robert Cecil Martin's Clean code, he recommend use an ```Integer``` type property to logic calling test.
and you just return a successful dummy response.

## STEP 3: Spy Test
Af first, you can write extension of CardInteractorTests with marking use case.
> IMO, Marking use case test name helps to understand test logic. It also helps your colleagues.
```swift

// MARK: - Fetch Card

extension CardInteractorTests {

}
```
and next, you have to define expectations such as fetch success & fetch failed

```swift

// MARK: - Fetch Card

extension CardInteractorTests {

  // success
  func testFetchCardShouldBeFailedWithoutCardID() {
  
  }
  
  // failed
  func testFetchCardShouldBeSuccessWithCardID() {
  
  }
}
```
and you just follow [BDD](https://en.wikipedia.org/wiki/Behavior-driven_development)
> befre: Fetch Card BDD Spec
```
Fetch Card Must be Success!

Given: worker is defined and cardID isn't nil
When: interactor.fetchCard called
Then: worker.getCard must be called once.

```
> after
```swift

  func testFetchCardShouldBeFailedWithoutCardID() {
    // given
    let worker = Spy_CardWorker() // worker is defined 
    self.interactor.worker = worker
    
    self.interactor.cardID = nil // cardID isn't nil
    
    // when
    self.interactor.fetchCard(request: CardModels.FetchCard.Request()) // interactor.fetchCard called
    
    // then
    expect(worker.getCardCalled).toEventually(equal(0)) // worker.getCard must be called once.
  }
```

# Pagination Flow
<img src="https://github.com/GeekTree0101/EffectiveInteractorProject/blob/master/res/preview2.png" />
