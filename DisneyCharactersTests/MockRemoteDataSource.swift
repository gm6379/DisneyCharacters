//
//  MockRemoteDataSource.swift
//  DisneyCharactersTests
//
//  Created by George McDonnell on 26/03/2023.
//

import Foundation
@testable import DisneyCharacters

class MockRemoteDataSource: DataSource {
    
    typealias DataType = DisneyCharacter
    
    private let data: [DisneyCharacter] = [.mock(), .mock2(), .mock3(), .mock4(), .mock5(), .mock6()]
    
    func readData() async -> Result<[DisneyCharacters.DisneyCharacter], Error> {
        return .success(data)
    }
    
}
