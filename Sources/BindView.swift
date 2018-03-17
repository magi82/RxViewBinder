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

import RxSwift

public protocol BindView: class {
  associatedtype ViewModel
  
  var disposeBag: DisposeBag { get set }
  var viewModel: ViewModel? { get set }
  
  func state(viewModel: ViewModel)
  func command(viewModel: ViewModel)
}

// MARK: - disposeBag

private var disposeBagKey: String = "disposeBag"
extension BindView {
  
  public var disposeBag: DisposeBag {
    get {
      if let value = objc_getAssociatedObject(self,
                                              &disposeBagKey) as? DisposeBag {
        return value
      }
      
      let disposeBag = DisposeBag()
      
      objc_setAssociatedObject(self,
                               &disposeBagKey,
                               disposeBag,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return disposeBag
    }
    
    set {
      objc_setAssociatedObject(self,
                               &disposeBagKey,
                               newValue,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

// MARK: - viewModel

private var viewModelKey: String = "viewModel"
extension BindView {
  
  public var viewModel: ViewModel? {
    get {
      if let value = objc_getAssociatedObject(self,
                                              &viewModelKey) as? ViewModel {
        return value
      }
      
      return nil
    }
    
    set {
      objc_setAssociatedObject(self,
                               &viewModelKey,
                               newValue,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

      let viewController = self as? UIViewController
      viewController?.rx.methodInvoked(#selector(UIViewController.loadView))
        .asObservable()
        .map { _ in newValue }
        .subscribe(onNext: { [weak self] in
          self?.binding(viewModel: $0)
        })
        .disposed(by: self.disposeBag)
    }
  }
  
  func binding(viewModel: ViewModel?) {
    if let viewModel = viewModel {
      state(viewModel: viewModel)
      command(viewModel: viewModel)
    }
  }
}
