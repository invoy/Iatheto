//
//  JSONEncodable.swift
//  Iatheto
//
//  Created by Gregory Higley on 6/5/17.
//  Copyright © 2017 Gregory Higley. All rights reserved.
//

import Foundation

/**
 Encoding is the act of turning something into JSON.
*/ 
public protocol JSONEncodable {
    func encode(state: Any?) throws -> JSON
}

extension JSONEncodable {
    public func encode() throws -> JSON {
        return try encode(state: nil)
    }
    
    public func encode(state: Any? = nil, options: JSONSerialization.WritingOptions = []) throws -> Data {
        return try encode(state: state).rawData()
    }
    
    public func encode(state: Any? = nil, options: JSONSerialization.WritingOptions = []) throws -> String? {
        return try String(data: encode(state: state, options: options), encoding: .utf8)
    }
}

