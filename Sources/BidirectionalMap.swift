//
//  BidirectionalMap.swift
//  Wing
//
//  Created by Tom Wilkinson on 3/31/16.
//  Copyright © 2016 Sparo, Inc. All rights reserved.
//

import Foundation

private extension Dictionary {
    /**
     Returns the element at the given optional index if index is not optional

     - parameter index: Index?
     - returns: Element?
     */
    subscript (safe key: Key?) -> Value? {
        get {
            guard let key = key else {
                return nil
            }
            return self[key]
        }
        set {
            guard let key = key else {
                return
            }
            self[key] = newValue
        }
    }
}

public struct BidirectionalMap<Key: Hashable, Value: Hashable>:
CollectionType, DictionaryLiteralConvertible {
    public typealias Element = (Key, Value)
    public typealias Index = BidirectionalMapIndex<Key, Value>
    private var leftDictionary: [Key: Value]
    private var rightDictionary: [Value: Key]

    /**
     Create an empty bidirectional map.
     */
    public init() {
        leftDictionary = [:]
        rightDictionary = [:]
    }

    /**
     Create a bidirectional map with a minimum capacity.  The true capacity will be the smallest
     power of 2 greater than `minimumCapacity`.

     - parameter minimumCapacity:
     */
    public init(minimumCapacity: Int) {
        leftDictionary = [Key: Value](minimumCapacity: minimumCapacity)
        rightDictionary = [Value: Key](minimumCapacity: minimumCapacity)
    }

    /**
     Create a bidirectional map with the sequence.

     If more than one key exists for a value, one of them will be nondeterministically chosen

     - parameter sequence:
     */
    public init<S: SequenceType where S.Generator.Element == (Key, Value)>(_ sequence: S) {
        self.init(minimumCapacity: sequence.underestimateCount())
        for (key, value) in sequence {
            self[key] = value
        }
    }

    /**
     The position of the first element in a non-empty bidirectional map

     Identical to `endIndex` in an empty bidirectional map

     - Complexity: Amortized O(1) if `self` does not wrap a bridged
     `NSDictionary`, O(N) otherwise
     - returns: BidirectionalMapIndex
     */
    public var startIndex: BidirectionalMapIndex<Key, Value> {
        return BidirectionalMapIndex(dictionaryIndex: leftDictionary.startIndex)
    }

    /**
     The position of the last element in a non-empty bidirectional map.

     Identical to `endIndex` in an empty bidirectional map.

     - Complexity: Amortized O(1) if `self` does not wrap a bridged
     `NSDictionary`, O(N) otherwise
     - returns: BidirectionalMapIndex
     */
    public var endIndex: BidirectionalMapIndex<Key, Value> {
        return BidirectionalMapIndex(dictionaryIndex: leftDictionary.endIndex)
    }

    /**
     - parameter key:
     - returns: `Index` for the given key, or `nil` if the key is not present
     in the bidirectional map
     */
    @warn_unused_result
    public func indexForKey(key: Key) -> BidirectionalMapIndex<Key, Value>? {
        return BidirectionalMapIndex(dictionaryIndex: leftDictionary.indexForKey(key))
    }

    /**
     - parameter value:
     - returns: `Index` for the given value, or `nil` if the value is not present
     in the bidirectional map
     */
    @warn_unused_result
    public func indexForValue(value: Value) -> BidirectionalMapIndex<Key, Value>? {
        guard let key = rightDictionary[value] else {
            return nil
        }
        return BidirectionalMapIndex(dictionaryIndex: leftDictionary.indexForKey(key))
    }

    /**
     - parameter position:
     - returns: `(Key, Value)` pair for the `Index`
     */
    public subscript (position: BidirectionalMapIndex<Key, Value>) -> (Key, Value) {
        return leftDictionary[position.dictionaryIndex]
    }

    /**
     This behaves exactly as does the normal `Dictionary` subscript, except that
     here key is also an Optional, and if nil will always return nil (and won't do anything
     for a set)

     - parameter key:
     - returns: Value?
     */
    public subscript (key: Key?) -> Value? {
        get {
            guard let key = key else {
                return nil
            }
            return leftDictionary[key]
        }
        set {
            guard let key = key else {
                return
            }
            setKeyAndValue(key, value: newValue)
        }
    }

    /**
     This will behave the same as subscript with key, except it
     uses the value to do the lookup

     - parameter value: Optional value of the bidirectional map
     - returns: Key?
     */
    public subscript (value value: Value?) -> Key? {
        get {
            guard let value = value else {
                return nil
            }
            return rightDictionary[value]
        }
        set(newKey) {
            guard let value = value else {
                return
            }
            setKeyAndValue(newKey, value: value)
        }
    }

    /**
     Private helper to set both the key and the value.

     - parameter key:
     - parameter value:
     */
    private mutating func setKeyAndValue(key: Key?, value: Value?) {
        leftDictionary[safe: rightDictionary[safe: value]] = nil
        rightDictionary[safe: leftDictionary[safe: key]] = nil
        leftDictionary[safe: key] = value
        rightDictionary[safe: value] = key
    }

    /**
     Update the value stored in the dicationary for the given key, or, if the
     key does not exist, add a new key-value pair to the bidirectional map.

     - parameter value:
     - parameter forKey:
     - returns: The value that was replaced, or `nil` if a new key-value pair
     was added.
     */
    public mutating func updateValue(value: Value, forKey key: Key) -> Value? {
        let oldValue = self[key]
        self[key] = value
        return oldValue
    }

    /**
     Update the key stored in the dicationary for the given value, or, if the
     value does not exist, add a new key-value pair to the bidirectional map.

     - parameter key:
     - parameter forValue:
     - returns: The value that was replaced, or `nil` if a new key-value pair
     was added.
     */
    public mutating func updateKey(key: Key, forValue value: Value) -> Key? {
        let oldKey = self[value: value]
        self[value: value] = key
        return oldKey
    }

    /**
     Remove the key-value pair at `index`

     Invalidates all indices with respect to `self`.

     - Complexity: O(`self.count`)
     - returns: The removed `Element`
     */
    public mutating func removeAtIndex(index: BidirectionalMapIndex<Key, Value>) -> (Key, Value) {
        let pair = leftDictionary.removeAtIndex(index.dictionaryIndex)
        rightDictionary.removeValueForKey(pair.1)
        return pair
    }

    /**
     Removes a given key and its value from the bidirectional map.

     - parameter key:
     - returns: The value that was removed, or `nil` if the key was not present
     in the bidirectional map
     */
    public mutating func removeValueForKey(key: Key) -> Value? {
        guard let value = leftDictionary.removeValueForKey(key) else {
            return nil
        }
        rightDictionary.removeValueForKey(value)
        return value
    }

    /**
     Removes a given value and its key from the bidirectional map.

     - parameter value:
     - returns: The key that was removed, or `nil` if the value was not present
     in the bidirectional map
     */
    public mutating func removeKeyForValue(value: Value) -> Key? {
        guard let key = rightDictionary.removeValueForKey(value) else {
            return nil
        }
        leftDictionary.removeValueForKey(key)
        return key
    }

    /**
     Removes all elements.

     - Postcondition: `capacity == 0` if `keepCapacity` is `false`, othwerise
     the capacity will not be decreased.

     Invalidates all indices with respect to `self`.

     - parameter keepCapacty: If `true`, the operation preserves the storage capacity
     that the collection has, otherwise the underlying storage is released. The default
     is `false`.

     - Complexity: O(`self.count`).
     */
    public mutating func removeAll(keepCapacity keepCapacity: Bool = false) {
        leftDictionary.removeAll(keepCapacity: keepCapacity)
        rightDictionary.removeAll(keepCapacity: keepCapacity)
    }

    /**
     The number of entries in the dictionary.

     - Complexity: O(1)
     */
    public var count: Int {
        return leftDictionary.count
    }

    /**
     - returns: A generator over the (key, value) pairs.
     - Complexity: O(1).
     */
    public func generate() -> BidirectionalMapGenerator<Key, Value> {
        return BidirectionalMapGenerator(dictionaryGenerator: leftDictionary.generate())
    }

    /**
     Create an instance initialized with `elements`.

     - parameter elements:
     */
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(minimumCapacity: elements.count)
        for (key, value) in elements {
            leftDictionary[key] = value
            rightDictionary[value] = key
        }
    }

    /**
     A collection containing just the keys of `self`.

     Keys appear in the same order as they occur in the `.0` member
     of key-value pairs in `self`.  Each key in the result has a
     unique value.
     */
    public var keys: LazyMapCollection<BidirectionalMap<Key, Value>, Key> {
        return self.lazy.map { $0.0 }
    }

    /**
     A collection containing just the values of `self`.

     Values appear in the same order as they occur in the `.1` member
     of key-value pairs in `self`.  Each vaue in the result has a unique
     value.
     */
    public var values: LazyMapCollection<BidirectionalMap<Key, Value>, Value>  {
        return self.lazy.map { $0.1 }
    }

    /// `true` iff `count == 0`.
    public var isEmpty: Bool {
        return leftDictionary.isEmpty
    }
}

extension BidirectionalMap : CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        return leftDictionary.description
    }
    /// A textual representation of `self`, suitable for debugging.
    public var debugDescription: String {
        return leftDictionary.description
    }
}

extension BidirectionalMap {
    /**
     If `!self.isEmpty`, return the first key-value pair in the sequence of
     elements, otherwise return `nil`.

     - Complexity: Amortized O(1)
     */
    public mutating func popFirst() -> (Key, Value)? {
        guard !isEmpty else {
            return nil
        }
        return removeAtIndex(startIndex)
    }
}

/// A generator over the members of a `BidirectionalMap<Key, Value>`.
public struct BidirectionalMapGenerator<Key: Hashable, Value: Hashable> : GeneratorType {
    private var dictionaryGenerator: DictionaryGenerator<Key, Value>

    /**
     Create a new bidirectional map generate wrapper over the dictionary generator

     - parameter dictionaryGenerator:
     */
    private init?(dictionaryGenerator: DictionaryGenerator<Key, Value>?) {
        guard let dictionaryGenerator = dictionaryGenerator else {
            return nil
        }
        self.dictionaryGenerator = dictionaryGenerator
    }

    /**
     Create a new bidirectional map generate wrapper over the dictionary generator

     - parameter dictionaryGenerator:
     */
    private init(dictionaryGenerator: DictionaryGenerator<Key, Value>) {
        self.dictionaryGenerator = dictionaryGenerator
    }

    /**
     Advance to the next element and return in, or `nil` if no next
     element exists.

     - Requires: No preceding call to `self.next()` has returned `nil`.
     */
    public mutating func next() -> (Key, Value)? {
        return dictionaryGenerator.next()
    }
}

/**
 Less than operator for bidirectional map index

 - parameter lhs:
 - parameter rhs:
 - returns: Bool
 */
public func < <Key: Hashable, Value: Hashable>(
    lhs: BidirectionalMapIndex<Key, Value>, rhs: BidirectionalMapIndex<Key, Value>) -> Bool
{
    return lhs.dictionaryIndex < rhs.dictionaryIndex
}

/**
 Less than or equal to operator for bidirectional map index

 - parameter lhs:
 - parameter rhs:
 - returns: Bool
 */
public func <= <Key: Hashable, Value: Hashable>(
    lhs: BidirectionalMapIndex<Key, Value>, rhs: BidirectionalMapIndex<Key, Value>) -> Bool
{
    return lhs.dictionaryIndex <= rhs.dictionaryIndex
}

/**
 Greater than operator for bidirectional map index

 - parameter lhs:
 - parameter rhs:
 - returns: Bool
 */
public func > <Key: Hashable, Value: Hashable>(
    lhs: BidirectionalMapIndex<Key, Value>, rhs: BidirectionalMapIndex<Key, Value>) -> Bool
{
    return lhs.dictionaryIndex > rhs.dictionaryIndex
}

/**
 Greater than or equal operator for bidirectional map index

 - parameter lhs:
 - parameter rhs:
 - returns: Bool
 */
public func >= <Key: Hashable, Value: Hashable>(
    lhs: BidirectionalMapIndex<Key, Value>, rhs: BidirectionalMapIndex<Key, Value>) -> Bool
{
    return lhs.dictionaryIndex >= rhs.dictionaryIndex
}

/**
 Equal operator for bidirectional map index

 - parameter lhs:
 - parameter rhs:
 - returns: Bool
 */
public func == <Key: Hashable, Value: Hashable>(
    lhs: BidirectionalMapIndex<Key, Value>, rhs: BidirectionalMapIndex<Key, Value>) -> Bool
{
    return lhs.dictionaryIndex == rhs.dictionaryIndex
}

/**
 Used to access the key-value pairs in an instance of `BidirectionalMap<Key, Value>`.

 Bidirectional map has three subscripting interfaces:

 1.  Subscripting with an optional key, yielding an optional value:

        v = d[k]!

 2.  Subscripting with an optional value, yielding an optional key:

        k = d[k]!

 3.  Subscripting with an index, yielding a key-value pair:

        (k, v) = d[i]
 */
public struct BidirectionalMapIndex<Key: Hashable, Value: Hashable> : ForwardIndexType, Comparable {
    private let dictionaryIndex: DictionaryIndex<Key, Value>

    /**
     Create a new bidirectional map index from the underlying dictionary index

     - parameter dictionaryIndex:
     */
    private init?(dictionaryIndex: DictionaryIndex<Key, Value>?) {
        guard let dictionaryIndex = dictionaryIndex else {
            return nil
        }
        self.dictionaryIndex = dictionaryIndex
    }

    /**
     Create a new bidirectional map index from the underlying dictionary index

     - parameter dictionaryIndex:
     */
    private init(dictionaryIndex: DictionaryIndex<Key, Value>) {
        self.dictionaryIndex = dictionaryIndex
    }

    /**
     - Requires: The next value is representable.
     - returns: The next consecutive value after `self`.
     */
    public func successor() -> BidirectionalMapIndex<Key, Value> {
        return BidirectionalMapIndex(dictionaryIndex: dictionaryIndex.successor())
    }
}
