## 1.8.0
* **FEATURE:** Added `yMinValue` and `yMaxValue` on `FLChart` to clip the chart y axis.
* **FIX:** Bar animation.
* **IMPROVEMENT:** `limitWidth` behaviour.


## 1.7.0
* **FEATURE:** Added `FLHorizontalMultipleValuesChartBar` to display multiple values with single bars side by side.
* **IMPROVEMENT:** Added method to update average value in `FLCard`.
* **IMPROVEMENT:** Added possibility to limit the width of the bars if scroll is enabled.


## 1.6.0
* **FEATURE:** Added possibility to choose color of the line of line chart for each x and y segment.
* **FEATURE:** Added possibility to create segmented gradients in `FLColor`.
* **FIX:** Fixed bug with drawing axes when device orientation changes.


## 1.5.0
* **FEATURE:** Added radar chart.

## 1.4.1
* **FIX:** Fix duplicated Y axise labels.

## 1.4.0
* **FEATURE:** Added pie chart.
* **FEATURE:** Added possibility to create your own `FLLegend` view.

## 1.3.1
* **FEATURE:** Added formatters and unit of measure labels for x and y axes.
* **FIX:** Fixed crash if `FLChartData` contains few data.

## 1.3.0
* **FEATURE:** Added Scatter chart
* **FIX:** Fixed `shouldScroll` property.


## 1.2.1
* **FEATURE:** Added support for Storyboard

## 1.2.0
* **FEATURE:** Added support for line chart
* **FEATURE:** Added predefined colors and gradients
* **FEATURE:** Added support for legend in `FLCard`
* **IMPROVEMENT:** Fixed FLCard header labels compression
* **IMPROVEMENT:** Changed data entry type with `SinglePlotable` and `MultiPlotable`

## 1.1.1
* **IMPROVEMENT:** Fixed NSLayoutConstraint+XT.swift file

## 1.1.0
* **FEATURE:** Added Legend option in FLCard
* **IMPROVEMENT:** Fixed Package.swift file

## 1.0.6
* **FEATURE:** Added support for DarkMode
* **FEATURE:** Added FLCard to embed a chart inside a card along with a title and an average label
* **FEATURE:** Added possibility to choose y axis position (left or right)
* **WIKI:** Added FLCard example
* **IMPROVEMENT:** Added fine grained configurations
* **IMPROVEMENT:** Added `ChartHighlightingDelegate` to be informed on the state of the highlight view
* **IMPROVEMENT:** Added .DS_Store to .gitignore
* **IMPROVEMENT:** Added calculation for chart margin based on y axis labels widths

## 1.0.5
* **IMPROVEMENT:** Switched custom bar creation from subclass to protocol `ChartBar`

## 1.0.0 - Released (11 January 2022)
