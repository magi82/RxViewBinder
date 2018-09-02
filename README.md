# RxViewBinder

![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)
[![Platform](https://img.shields.io/cocoapods/p/RxViewBinder.svg?style=flat)](http://cocoapods.org/pods/RxViewBinder)
[![Version](https://img.shields.io/cocoapods/v/RxViewBinder.svg?style=flat)](http://cocoapods.org/pods/RxViewBinder)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/RxViewBinder.svg?style=flat)](http://cocoapods.org/pods/RxViewBinder)

RxViewBinder is a simple one-way architecture.<br>
Simple and easy to implement. :sunny:

It is implemented as a reactive extension.

## Flow

<img src="https://github.com/magi82/RxViewBinder/blob/develop/Resources/flow.png?raw=true">

## Usage (ViewBindable)

- Create a ViewBinder class that implements ViewBindable.
<br>Command, Action, State must be implemented.
<br>Command is enum type.
<br>Action, State is structure type.

*important!!*
<br>You need to bind the action and state in the constructor of the state structure.

```swift
final class SampleViewBinder: ViewBindable {
  
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
}
```

- implements a binding method that accepts a command stream and sends the stream to action.
<br>When changing the state of ui, only action is used.
<br>state is used only when the view receives the state of ui.

```swift
  func binding(command: Command) {
    switch command {
    case .fetch:
      Observable<String>.just("test")
        .bind(to: action.value)
        .disposed(by: self.disposeBag)
    }
  }
```

- Or you can simply send the stream without creating an observer.

```swift
  func binding(command: Command) {
    switch command {
    case .fetch:
      action.value.accept("test")
    }
  }
```

## Usage (BindView)

- Implement the BindView protocol on the view controller.
<br>It injects the view binder at initialization.

```swift
final class ViewController: UIViewController, BindView {

  typealias ViewBinder = SampleViewBinder
  
  init(viewBinder: ViewBinder) {
    defer { self.viewBinder = viewBinder }
    
    super.init(nibName: nil, bundle: nil)
  }
}
```

- If you are using a storyboard, you have to inject it in a different way.

```swift
  let vc = ViewController()
  vc.viewBinder = SampleViewBinder()
```

or 

```swift
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.viewBinder = ViewBinder()
  }
```

- Implements the command and state methods.

```swift
  func command(viewBinder: ViewBinder) {
    self.rx.methodInvoked(#selector(UIViewController.viewDidLoad))
      .map { _ in ViewBinder.Command.fetch }
      .bind(to: viewBinder.command)
      .disposed(by: self.disposeBag)
  }
  
  func state(viewBinder: ViewBinder) {
    viewBinder.state
      .value
      .drive(onNext: { print($0) })
      .disposed(by: self.disposeBag)
  }
```

## Requirements

- Swift 4.0+
- iOS 9.0+

## Installation

- **For iOS 9+ projects** with [CocoaPods](https://cocoapods.org):

```ruby
pod 'RxViewBinder', '~> 1.0.0'
```

- **For iOS 9+ projects** with [Carthage](https://github.com/Carthage/Carthage):

```ruby
github "magi82/RxViewBinder" ~> 1.0.0
```

## Author

magi82, devmagi82@gmail.com

## License

**RxViewBinder** is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
