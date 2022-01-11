#
# Be sure to run `pod lib lint FLCharts.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FLCharts'
  s.version          = '1.0.2'
  s.summary          = 'Customizable iOS Charts built in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Easy to use and highly customizable charts for iOS. Use your own bar view.
                        DESC

  s.homepage         = 'https://github.com/francescoleoni98/FLCharts'
  s.swift_versions   = '5.0'
s.screenshots     = 'https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/base_chart.jpg', 'https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/highlightedview_chart.jpg', 'https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/multiple_value_chart.jpg'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'francescoleoni98' => 'leoni.francesco98@gmail.it' }
  s.source           = { :git => 'https://github.com/francescoleoni98/FLCharts.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/fraleo695'

  s.ios.deployment_target = '11.0'

  s.source_files = 'Sources/FLCharts/**/*'
  
  # s.resource_bundles = {
  #   'FLCharts' => ['FLCharts/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
