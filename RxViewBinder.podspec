Pod::Spec.new do |s|
  s.name             = 'RxViewBinder'
  s.version          = '2.0.0'
  s.summary          = 'RxViewBinder is a simple one-way architecture.'
  s.description      = <<-DESC
RxViewBinder is a one-way architecture using Reactive Extension.
                       DESC
  s.homepage         = 'https://github.com/magi82/RxViewBinder'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'magi82' => 'devmagi82@gmail.com' }
  s.source           = { :git => 'https://github.com/magi82/RxViewBinder.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/*.swift'
  s.dependency 'RxSwift', '~> 5.0'
  s.dependency 'RxCocoa', '~> 5.0'
  s.swift_version = '5.0'
end
