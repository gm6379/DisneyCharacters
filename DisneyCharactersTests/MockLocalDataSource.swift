//
//  MockLocalDataSource.swift
//  DisneyCharactersTests
//
//  Created by George McDonnell on 26/03/2023.
//

import Foundation
@testable import DisneyCharacters

class MockLocalDataSource: MutableDataSource {
    typealias DataType = DisneyCharacter

    private var store = [String : DisneyCharacter]()
    
    func add(data: [DisneyCharacters.DisneyCharacter]) async throws {
        data.forEach { character in
            store[UUID().uuidString] = character
        }
    }
    
    func readData() async -> Result<[DisneyCharacters.DisneyCharacter], Error> {
        return .success(Array(store.values))
    }
    
    
    func clear() async throws {
        return store.removeAll()
    }
    
}
