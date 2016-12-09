Pod::Spec.new do |s|

  s.name             = 'RxCoreMotion'
  s.version          = '0.3.0'
  s.summary          = 'An Rx wrapper of Apple iOS CoreMotion framework'

  s.description      = <<-DESC
    This is an Rx extension that provides an easy and straight-forward way
    to use Apple iOS CoreMotion responses as Observables
                       DESC

  s.homepage         = 'https://github.com/RxSwiftCommunity/RxCoreMotion'
  s.license          = 'MIT'
  s.author           = { 'Carlos García' => 'carlosypunto@gmail.com' }
  s.source           = { 
                          :git => "https://github.com/RxSwiftCommunity/RxCoreMotion.git"
                          :tag => s.version.to_s
                       }

  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  s.source_files = 'Pod/Classes/*.swift'

  s.frameworks = 'Foundation', 'CoreMotion'
  s.dependency 'RxSwift'

end
