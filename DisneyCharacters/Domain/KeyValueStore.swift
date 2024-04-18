//
//  KeyValueStore.swift
//  DisneyCharacters
//
//  Created by George McDonnell on 26/03/2023.
//

import Foundation

protocol KeyValueStore {
    
    func set<V>(key: String, value: V)
    
    func remove(key: String)
    
    func get<V>(for key: String) -> V?
}

struct LocalKeyValueStore: KeyValueStore {
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func set<V>(key: String, value: V) {
        userDefaults.set(value, forKey: key)
    }
    
    func get<V>(for key: String) -> V? {
        return userDefaults.value(forKey: key) as? V
    }
    
    func remove(key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
