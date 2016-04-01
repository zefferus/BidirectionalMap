# BidirectionalMap

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/BidirectionalMap.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/l/BidirectionalMap.svg)]()

Bidirectional map is a pure swift implementation that allows for O(1) lookup time using values, and guaranteees a strict 1:1 relationship between keys and values.  The map is almost an exact extension of Dictionary, with all the same methods and behavior.

Both the Key and the Value must be `Hashable` to create a `BidirectionalMap`

## Example

```swift
var bidirectionalMap: BidirectionalMap<String, Int> = [
  "Apple": 1, "Orange": 2, "Lemon": 3, "Banana": 4]
// Supports key and value access
bidirectionalMap["Apple"] // 1
bidirectionalMap[value: 1] // "Apple"
// Supports key and value setting
bidirectionalMap["Watermelon"] = 5
bidirectionalMap[value: 6] = "Grape"
bidirectionalMap[value: 5] // "Watermelon"
bidirectionalMap["Grape"] // 6
// Supports updating key and values
bidirectionalMap["Orange"] = 6
bidirectionalMap[6] // "Orange"
bidirectionalMap["Grape"] // nil
bidirectionalMap[6] = nil
```

The Bidirectional Map supports all the normal dictionary functions and indexing and the value versions where appropriate.

## Install
Can be installed by downloading the source file and copying, through Cocoapods, or Carthage

## Implementation

The bidirectional map is internally implemented as two maps.  If objects are stored by value (`Int`, `String`, etc.) this will double the required space.  For objects stored by reference (`AnyObject`), the required space is double for the references but not the objects themselves.
