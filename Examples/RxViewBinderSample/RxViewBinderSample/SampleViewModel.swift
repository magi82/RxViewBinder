// The MIT License (MIT)
//
// Copyright (c) 2018 ByungKook Hwang (https://magi82.github.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

import RxSwift
import RxCocoa
import RxViewBinder

final class SampleViewModel: ViewBindable {
  
  enum Command {
    case fetch
  }
  
  struct Action {
    let value: PublishRelay<String> = PublishRelay()
  }
  
  struct State {
    let value: Driver<String>
    
    init(action: Action) {
      // Action and state binding
      value = action.value.asDriver(onErrorJustReturn: "")
    }
  }
  
  let action = Action()
  lazy var state = State(action: self.action)
  
  func binding(command: Command) {
    switch command {
    case .fetch:
      Observable<String>.just("test")
        .bind(to: action.value)
        .disposed(by: self.disposeBag)
      
      // Or you can simply send the stream without creating an observer.
      // action.value.accept("test")
    }
  }
}
