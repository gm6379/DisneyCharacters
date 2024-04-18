//
//  MockKeyValueStore.swift
//  DisneyCharactersTests
//
//  Created by George McDonnell on 26/03/2023.
//

import Foundation
@testable import DisneyCharacters

class MockKeyValueStore: KeyValueStore {
    
    private var store = [String : Any]()
    
    func set<V>(key: String, value: V) {
        store[key] = value
    }
    
    func remove(key: String) {
        store[key] = nil
    }
    
    func get<V>(for key: String) -> V? {
        return store[key] as? V
    }
    
}
