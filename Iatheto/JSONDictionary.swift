//
//  JSONDictionary.swift
//  Iatheto
//
//  Created by Gregory Higley on 6/5/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 `JSONDictionary` is effectively the same as `Dictionary<Key, JSON>`
 except that instead of returning `nil` when a key is not found, it
 returns `JSON.null`.
 */
public struct JSONDictionary: Equatable {
    fileprivate var dictionary: [String: JSON]
    
    public init() {
        dictionary = [String: JSON]()
    }
    
    public init(_ dictionary: [String: JSON]) {
        self.dictionary = dictionary
    }
}

extension JSONDictionary: Sequence {
    
    public func makeIterator() -> DictionaryIterator<String, JSON> {
        return dictionary.makeIterator()
    }
    
}

extension JSONDictionary: Collection {
    
    public var startIndex: Dictionary<String, JSON>.Index {
        return dictionary.startIndex
    }
    
    public var endIndex: Dictionary<String, JSON>.Index {
        return dictionary.endIndex
    }
    
    public subscript(position: Dictionary<String, JSON>.Index) -> Dictionary<String, JSON>.Element {
        return dictionary[position]
    }
    
    public func index(after i: Dictionary<String, JSON>.Index) -> Dictionary<String, JSON>.Index {
        return dictionary.index(after: i)
    }
    
    public subscript(key: String) -> JSON {
        get { return dictionary[key] ?? .null }
        set { dictionary[key] = newValue }
    }
    
    public subscript(keypath: KeyPath) -> JSON {
        get {
            let keypaths = keypath.flatten()
            switch keypaths.count {
            case 0:
                return .null
            case 1:
                if case .key(let key) = keypaths[0] {
                    return self[key]
                }
                return .null
            default:
                if case .key(let key) = keypaths[0] {
                    let rest = KeyPath(keypaths.suffix(from: 1))
                    return self[key][rest]
                }
                return .null
            }
        }
        set {
            let keypaths = keypath.flatten()
            switch keypaths.count {
            case 0:
                return
            case 1:
                if case .key(let key) = keypaths[0] {
                    self[key] = newValue
                }
            default:
                if case .key(let key) = keypaths[0] {
                    let rest = KeyPath(keypaths.suffix(from: 1))
                    self[key][rest] = newValue
                }
            }
        }
    }
    
    public func map(_ transform: (Dictionary<String, JSON>.Element) throws -> Dictionary<String, JSON>.Element) rethrows -> JSONDictionary {
        return try JSONDictionary(dictionary.map(transform).dictionary())
    }
    
    public func filter(_ predicate: (Dictionary<String, JSON>.Element) throws -> Bool) rethrows -> JSONDictionary {
        return try JSONDictionary(dictionary.filter(predicate).dictionary())
    }
    
}

extension JSONDictionary: ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (String, JSON)...) {
        dictionary = [String: JSON]()
        for (key, json) in elements {
            dictionary[key] = json
        }
    }
    
}

public func ==(lhs: JSONDictionary, rhs: JSONDictionary) -> Bool {
    return lhs.dictionary == rhs.dictionary
}

