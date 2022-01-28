#
# Be sure to run `pod lib lint FLCharts.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'FLCharts'
  s.version          = '1.2.2'
  s.summary          = 'Customizable iOS Charts built in Swift.'

  s.description      = <<-DESC
  Easy to use and highly customizable charts for iOS. Use your own bar view.
                        DESC

  s.homepage         = 'https://github.com/francescoleoni98/FLCharts'
  s.swift_versions   = '5.0'
  s.screenshots     = 'https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/base_chart.jpg', 'https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/highlightedview_chart.jpg', 'https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/multiple_value_chart.jpg'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Francesco Leoni' => 'leoni.francesco98@gmail.it' }
  s.source           = { :git => 'https://github.com/francescoleoni98/FLCharts.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/fraleo695'

  s.ios.deployment_target = '11.0'

  s.source_files = 'Sources/FLCharts/**/*.{swift}'
  s.resources = 'Sources/FLCharts/Assets/*'

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
