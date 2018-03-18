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

final class ViewController: UIViewController, BindView {
  
  typealias ViewModel = SampleViewModel
  
  init(viewModel: ViewModel) {
    defer { self.viewModel = viewModel }
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func command(viewModel: ViewModel) {
    self.rx.methodInvoked(#selector(UIViewController.viewDidLoad))
      .map { _ in ViewModel.Command.fetch }
      .bind(to: viewModel.command)
      .disposed(by: self.disposeBag)
  }
  
  func state(viewModel: ViewModel) {
    viewModel.state
      .value
      .drive(onNext: { print($0) })
      .disposed(by: self.disposeBag)
  }
}
