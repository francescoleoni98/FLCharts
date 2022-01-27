![FLCharts](https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/FLCharts_icon.png)

# FLCharts

![Version](https://img.shields.io/cocoapods/v/FLCharts.svg?style=flat) ![Platforms](https://img.shields.io/cocoapods/p/FLCharts.svg?style=flat) ![License](https://img.shields.io/cocoapods/l/FLCharts.svg?style=flat) ![Swift](https://img.shields.io/badge/swift-5.0-brightgreen.svg) ![Xcode 11.0+](https://img.shields.io/badge/Xcode-11.0%2B-blue.svg) ![iOS 11.0+](https://img.shields.io/badge/iOS-11.0%2B-blue.svg) [![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

FLCharts is an easy-to-use library to build highly customizable bar charts. It allows you to create your own chart bar `UIView` and use it to display data in the chart.
<br>
Additionally FLCharts allows you to provide a custom `HighlightedView` to show the highlighted bar contents on top of the chart.
<br>
Embed effortlessly your chart in a `FLCard` alogside with a title, an average vlue view and additional behaviours.


# Table of Contents
* [Requirements](#requirements)
* [Installation](#installation)
* [Features](#features)
* [Configurations](#configurations)
* [Docs](#docs)
* [Examples](#examples)
* [Animations](#animations)
* [License](#license)


## Requirements <a name="requirements"></a>
* Xcode 11 / Swift 5
* iOS >= 11.0


## Installation <a name="installation"></a>

FLCharts is available through [CocoaPods](https://cocoapods.org). To install it, add the following line to your Podfile:

```ruby
pod 'FLCharts'
```
<br>
Here you can find a guide about how to setup a bar chart using FLCharts: <br>
https://medium.com/@leonifrancesco/set-up-a-basic-bar-chart-using-flcharts-swift-d2f615a10d0b

## Features <a name="features"></a>

 - Animations for chart bars
 - Customizable Axes (both x and y axis)
 - Dragging / Panning (with touch-gesture)
 - Highlighting values (with customizable popup-views)
 - Create custom cards with embedded chart and more features
 - Scroll through chart while highlighted to change highlighted bar
 - Fully customizable (bar colors, axes color, background, average value, dashed lines, ...)

## Configurations <a name="configurations"></a>

FLChart is highly customizable. You can choose which property to modify through the .config property.

```swift
let axisLabelConfig = FLAxisLabelConfig(color: .black,
                                        font: .preferredFont(forTextStyle: .body))

let config = ChartConfig(axesLabels: axisLabelConfig)
                         
chart.config.dashedLines.color = .darkGray
```


## Docs <a name="docs"></a>

You can build FLCharts documentation directly in XCode.
</br>
In XCode go to `Product -> Build Documentation`, once XCode has finished building, the documentation will appear.


## Examples <a name="examples"></a>

 - **Bar Chart**

 ![alt tag](https://github.com/francescoleoni98/FLCharts/blob/main/Screenshots/base_chart.jpg)

 - **Multivalue Bar Chart**

 ![alt tag](https://github.com/francescoleoni98/FLCharts/blob/main/Screenshots/multiple_value_chart.jpg)

 - **Highlighted Bar**

 ![alt tag](https://github.com/francescoleoni98/FLCharts/blob/main/Screenshots/highlightedview_chart.jpg)

 - **Average view**

 ![alt tag](https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/average_line.jpg)

 - **Bar chart embedded in FLCard**

 ![alt tag](https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/FLCard.jpg)

 - **Dark mode**

 ![alt tag](https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/dark_mode.jpg)


## Animations <a name="animations"></a>

- **Panning while highlighted**

 ![alt tag](https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/GIFs/highlighted_pan_animation.gif)

- **Chart animation**

 ![alt tag](https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/GIFs/start_bars_animation.gif)

- **Scrolling behaviour with average and highlighted views**

 ![alt tag](https://raw.githubusercontent.com/francescoleoni98/FLCharts/main/Screenshots/GIFs/scrolling_behaviour.gif)


## Author

Francesco Leoni | leoni.francesco98@gmail.it 
</br>
francescoleoni98 | https://github.com/francescoleoni98


## License <a name="license"></a>

FLCharts is available under the MIT license. See the LICENSE file for more info.
