//
//  Dictionary.swift
//  Iatheto
//
//  Created by Gregory Higley on 6/5/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value: JSONDecodable {
    public static func decode(json: JSON, state: Any? = nil) throws -> Dictionary<Key, Value>? {
        return try json.decodeDictionary { dictionary in
            return try dictionary.flatMap {
                guard let value = try Value.decode(json: $0.1, state: state) else { return nil }
                return (key: $0.0, value: value)
                }.dictionary()
        }
    }
    
    public static func decode(parsing string: String, state: Any? = nil) throws -> Dictionary<Key, Value>? {
        let json = try JSON(parsing: string)
        return try decode(json: json, state: state)
    }
    
    public static func decode(data: Data, state: Any? = nil) throws -> Dictionary<Key, Value>? {
        let json = try JSON(data: data)
        return try decode(json: json, state: state)
    }
    
    public static func decode(json: JSON, state: Any? = nil) throws -> Dictionary<Key, Value?>? {
        return try json.decodeDictionary { dictionary in
            try dictionary.map{ (key: $0.0, value: try Value.decode(json: $0.1, state: state)) }.dictionary()
        }
    }
    
    public static func decode(parsing string: String, state: Any? = nil) throws -> Dictionary<Key, Value?>? {
        let json = try JSON(parsing: string)
        return try decode(json: json, state: state)
    }
    
    public static func decode(data: Data, state: Any? = nil) throws -> Dictionary<Key, Value?>? {
        let json = try JSON(data: data)
        return try decode(json: json, state: state)
    }
}

extension Dictionary where Key == String, Value: JSONEncodable {
    public func encode(state: Any? = nil) throws -> JSON {
        var json = JSON()
        for (key, value) in self {
            json[key] = try value.encode(state: state)
        }
        return json
    }
}

extension Dictionary where Value == JSON {
    public func decode<T: JSONDecodable>(state: Any? = nil) throws -> [Key: T] {
        return try flatMap {
            guard let value = try T.decode(json: $0.1, state: state) else { return nil }
            return (key: $0.0, value: value)
            }.dictionary()
    }
    
    public func decode<T: JSONDecodable>(state: Any? = nil) throws -> [Key: T?] {
        return try map { (key: $0.0, value: try T.decode(json: $0.1, state: state)) }.dictionary()
    }
}

