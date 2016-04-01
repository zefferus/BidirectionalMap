//
//  BidirectionalMapTest.swift
//  Wing
//
//  Created by Tom Wilkinson on 3/31/16.
//  Copyright © 2016 Sparo, Inc. All rights reserved.
//

import XCTest
import BidirectionalMap

class BidirectionalMapTest: XCTestCase {
    func testInit() {
        let bidirectionalMap: BidirectionalMap<String, String> = BidirectionalMap<String, String>()
        XCTAssertEqual(bidirectionalMap.count, 0)
    }

    func testInitCapacity() {
        let expectedCapacity = 20
        let bidirectionalMap: BidirectionalMap<String, String> = BidirectionalMap<String, String>(
            minimumCapacity: expectedCapacity)
        XCTAssertEqual(bidirectionalMap.count, 0)
    }

    func testInitFromSequence() {
        let expectedDict: [String: Int] = ["One": 1, "Two": 2, "Three": 3, "Four": 4]
        let bidirectionalMap: BidirectionalMap<String, Int> = BidirectionalMap(expectedDict)
        for (key, value) in expectedDict {
            XCTAssertEqual(bidirectionalMap[key], value)
        }
    }

    func testInitFromSequenceNotOneToOne() {
        let expectedDict = ["One": 1, "Two": 2, "Three": 3, "Four": 4, "Five": 1, "Six": 2]
        let bidirectionalMap: BidirectionalMap<String, Int> = BidirectionalMap(expectedDict)
        for (key, value) in bidirectionalMap {
            XCTAssertEqual(expectedDict[key], value)
        }
        XCTAssertEqual(bidirectionalMap.count, Set(expectedDict.values).count)
    }

    func testStartIndex() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        let startIndex = bidirectionalMap.startIndex
        let element = bidirectionalMap[startIndex]
        XCTAssertEqual(bidirectionalMap[element.0], element.1)
    }

    func testEndIndex() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        let endIndex = bidirectionalMap.endIndex
        var index = bidirectionalMap.startIndex
        var count = 0
        while index != endIndex {
            count += 1
            index = index.successor()
        }
        XCTAssertEqual(count, bidirectionalMap.count)
    }

    func testStartEndIndexEmpty() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [:]
        XCTAssertEqual(bidirectionalMap.startIndex, bidirectionalMap.endIndex)
    }

    func testIndexForKey() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        for (key, value) in bidirectionalMap {
            if let index = bidirectionalMap.index(forKey: key) {
                XCTAssertEqual(bidirectionalMap[index].0, key)
                XCTAssertEqual(bidirectionalMap[index].1, value)
            } else {
                XCTFail()
            }
        }
        XCTAssertNil(bidirectionalMap.index(forKey: "not-in-map"))
    }

    func testIndexForValue() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        for (key, value) in bidirectionalMap {
            if let index = bidirectionalMap.index(forValue: value) {
                XCTAssertEqual(bidirectionalMap[index].0, key)
                XCTAssertEqual(bidirectionalMap[index].1, value)
            } else {
                XCTFail()
            }
        }
        XCTAssertNil(bidirectionalMap.index(forValue: -1))
    }

    func testSubscriptIndex() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        for (key, value) in bidirectionalMap {
            if let index = bidirectionalMap.index(forValue: value) {
                XCTAssertEqual(bidirectionalMap[index].0, key)
                XCTAssertEqual(bidirectionalMap[index].1, value)
            } else {
                XCTFail()
            }
        }
        var index = bidirectionalMap.startIndex
        while index != bidirectionalMap.endIndex {
            let (key, value) = bidirectionalMap[index]
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
            index = index.successor()
        }
    }

    func testSubscriptKeyGet() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[key], value)
        }
    }

    func testSubscriptKeySet() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertNil(bidirectionalMap["Five"])
        bidirectionalMap["Five"] = 5
        XCTAssertEqual(bidirectionalMap["Five"], 5)
        XCTAssertEqual(bidirectionalMap.count, 5)
        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[key], value)
            bidirectionalMap[key] = -value
            XCTAssertEqual(bidirectionalMap[key], -value)
        }
        XCTAssertEqual(bidirectionalMap.count, 5)
        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
        }
    }

    func testSubscriptValueGet() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[value: value], key)
        }
    }

    func testSubscriptValueSet() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertNil(bidirectionalMap[value: 5])
        bidirectionalMap[value: 5] = "Five"
        XCTAssertEqual(bidirectionalMap[value: 5], "Five")
        XCTAssertEqual(bidirectionalMap.count, 5)
        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[value: value], key)
            bidirectionalMap[value: value] = key + "New"
            XCTAssertEqual(bidirectionalMap[value: value], key + "New")
        }
        XCTAssertEqual(bidirectionalMap.count, 5)
        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
        }
    }

    func testUpdateValue() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertNil(bidirectionalMap.updateValue(5, forKey: "Five"))
        XCTAssertEqual(bidirectionalMap.updateValue(6, forKey: "Five"), 5)
        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
        }
    }

    func testUpdateKey() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertNil(bidirectionalMap.updateKey("Five", forValue: 5))
        XCTAssertEqual(bidirectionalMap.updateKey("FiveNew", forValue: 5), "Five")
        XCTAssertNil(bidirectionalMap["Five"])
        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
        }
    }

    func testRemoveAtIndex() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        guard let index = bidirectionalMap.index(forKey: "Two") else {
            XCTFail()
            return
        }
        let (key, value) = bidirectionalMap.remove(at: index)
        XCTAssertEqual(key, "Two")
        XCTAssertEqual(value, 2)
        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
        }
    }

    func testRemoveValueForKey() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertEqual(bidirectionalMap.removeValue(forKey: "Two"), 2)
        XCTAssertNil(bidirectionalMap.removeValue(forKey: "Five"))

        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
        }
    }

    func testRemoveKeyFoValue() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertEqual(bidirectionalMap.removeKey(forValue: 2), "Two")
        XCTAssertNil(bidirectionalMap.removeKey(forValue: 5))

        for (key, value) in bidirectionalMap {
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
        }
    }

    func testRemoveAll() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertEqual(bidirectionalMap.count, 4)
        bidirectionalMap.removeAll()
        XCTAssertEqual(bidirectionalMap.count, 0)
    }

    func testRemoveAllKeepCapacity() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertEqual(bidirectionalMap.count, 4)
        bidirectionalMap.removeAll(keepingCapacity: true)
        XCTAssertEqual(bidirectionalMap.count, 0)
    }

    func testCount() {
        var bidirectionalMap: BidirectionalMap<String, Int> = BidirectionalMap()
        XCTAssertEqual(bidirectionalMap.count, 0)
        for (index, value) in ["One", "Two", "Three", "Four"].enumerated() {
            bidirectionalMap[value] = index
            XCTAssertEqual(bidirectionalMap.count, index + 1)
        }
    }

    func testGenerate() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        var seenDict: [String: Int] = [:]
        for (key, value) in bidirectionalMap {
            seenDict[key] = value
        }
        XCTAssertEqual(seenDict.count, bidirectionalMap.count)
        for (key, value) in seenDict {
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
        }
    }

    func testInitDictionaryLiteral() {
        let dictionaryLiteral: DictionaryLiteral<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        let bidirectionalMap: BidirectionalMap<String, Int> = BidirectionalMap(dictionaryLiteral)
        let dict: [String: Int] = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        for (key, value) in dict {
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
        }
    }

    func testKeys() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertEqual(Set(bidirectionalMap.keys), Set(["One", "Two", "Three", "Four"]))
    }

    func testValues() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertEqual(Set(bidirectionalMap.values), Set([1, 2, 3, 4]))
    }

    func testIsEmpty() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertFalse(bidirectionalMap.isEmpty)
        bidirectionalMap.removeAll()
        XCTAssertTrue(bidirectionalMap.isEmpty)
    }

    func testDescription() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        let dict = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertEqual(bidirectionalMap.description, dict.description)
    }

    func testDebugDescription() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        let dict = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        XCTAssertEqual(bidirectionalMap.debugDescription, dict.debugDescription)
    }

    func testPopFirst() {
        var bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        while let (key, value) = bidirectionalMap.popFirst() {
            XCTAssertNil(bidirectionalMap[key])
            XCTAssertNil(bidirectionalMap[value: value])
        }
        XCTAssertTrue(bidirectionalMap.isEmpty)
    }

    func testGeneratorNext() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        var seenKeys: Set<String> = []
        var generator = bidirectionalMap.makeIterator()
        while let (key, value) = generator.next() {
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
            XCTAssertFalse(seenKeys.contains(key))
            seenKeys.insert(key)
        }
    }

    func testIndexLessThan() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        var index = bidirectionalMap.startIndex
        while index != bidirectionalMap.endIndex {
            XCTAssertLessThan(index, index.successor())
            index = index.successor()
        }
    }

    func testIndexLessThanOrEqual() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        var index = bidirectionalMap.startIndex
        while index != bidirectionalMap.endIndex {
            XCTAssertLessThanOrEqual(index, index.successor())
            XCTAssertLessThanOrEqual(index, index)
            index = index.successor()
        }
    }

    func testIndexEqual() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        var index = bidirectionalMap.startIndex
        while index != bidirectionalMap.endIndex {
            XCTAssertEqual(index, index)
            index = index.successor()
        }
    }

    func testIndexGreaterThan() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        var index = bidirectionalMap.startIndex
        while index != bidirectionalMap.endIndex {
            XCTAssertGreaterThan(index.successor(), index)
            index = index.successor()
        }
    }

    func testIndexGreaterThanOrEqual() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        var index = bidirectionalMap.startIndex
        while index != bidirectionalMap.endIndex {
            XCTAssertGreaterThan(index.successor(), index)
            XCTAssertGreaterThanOrEqual(index, index)
            index = index.successor()
        }
    }

    func testSuccessor() {
        let bidirectionalMap: BidirectionalMap<String, Int> = [
            "One": 1, "Two": 2, "Three": 3, "Four": 4
        ]
        var seenKeys: Set<String> = []
        var index = bidirectionalMap.startIndex
        while index != bidirectionalMap.endIndex {
            let (key, value) = bidirectionalMap[index]
            XCTAssertFalse(seenKeys.contains(key))
            seenKeys.insert(key)
            XCTAssertEqual(bidirectionalMap[key], value)
            XCTAssertEqual(bidirectionalMap[value: value], key)
            index = index.successor()
        }
    }

    func testBidirectionalMapWithObjects() {
        var bidirectionalMap: BidirectionalMap<NSObject, NSObject> = [:]
        var dict: [NSObject: NSObject] = [:]
        var keys: [NSObject] = []
        var values: [NSObject] = []
        for _ in 0..<50 {
            let key = NSObject()
            let value = NSObject()
            bidirectionalMap[key] = value
            dict[key] = value
            keys.append(key)
            values.append(value)
        }
        for _ in 0..<50 {
            let key = NSObject()
            let value = NSObject()
            bidirectionalMap[value: value] = key
            dict[key] = value
            keys.append(key)
            values.append(value)
        }
        for (key, value) in dict {
            XCTAssertTrue(bidirectionalMap[key] === value)
            XCTAssertTrue(bidirectionalMap[value: value] === key)
        }
        XCTAssertEqual(bidirectionalMap.count, dict.count)
        for _ in 0..<50 {
            let key = keys[Int(arc4random_uniform(UInt32(keys.count)))]
            let newValue = NSObject()
            bidirectionalMap[key] = newValue
            dict[key] = newValue
        }
        values = Array(dict.values)
        for _ in 0..<50 {
            let value = values[Int(arc4random_uniform(UInt32(values.count)))]
            let newKey = NSObject()
            let oldKey = bidirectionalMap[value: value]
            bidirectionalMap[value: value] = newKey
            dict[oldKey!] = nil
            dict[newKey] = value
        }
        for (key, value) in dict {
            XCTAssertTrue(bidirectionalMap[key] === value)
            XCTAssertTrue(bidirectionalMap[value: value] === key)
        }
        XCTAssertEqual(bidirectionalMap.count, dict.count)
    }
}
