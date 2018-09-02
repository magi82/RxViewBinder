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
  associatedtype ViewBinder
  
  var disposeBag: DisposeBag { get set }
  var viewBinder: ViewBinder? { get set }
  
  func state(viewBinder: ViewBinder)
  func command(viewBinder: ViewBinder)
  func binding(viewBinder: ViewBinder?)
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

// MARK: - viewBinder

private var viewBinderKey: String = "viewBinder"
extension BindView {
  
  public var viewBinder: ViewBinder? {
    get {
      if let value = objc_getAssociatedObject(self,
                                              &viewBinderKey) as? ViewBinder {
        return value
      }
      
      return nil
    }
    
    set {
      objc_setAssociatedObject(self,
                               &viewBinderKey,
                               newValue,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

      let viewController = self as? UIViewController
      viewController?.rx.methodInvoked(#selector(UIViewController.loadView))
        .asObservable()
        .map { _ in newValue }
        .subscribe(onNext: { [weak self] in
          self?.binding(viewBinder: $0)
        })
        .disposed(by: self.disposeBag)
    }
  }
  
  public func binding(viewBinder: ViewBinder?) {
    if let viewBinder = viewBinder {
      state(viewBinder: viewBinder)
      command(viewBinder: viewBinder)
    }
  }
}
