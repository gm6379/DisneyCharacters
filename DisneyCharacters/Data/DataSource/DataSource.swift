//
//  DataSource.swift
//  DisneyCharacters
//
//  Created by George McDonnell on 26/03/2023.
//

import Foundation

protocol DataSource {
    
    associatedtype DataType
    
    func readData() async -> Result<[DataType], Error>
    
}

protocol MutableDataSource: DataSource {
    
    associatedtype DataType
    
    func add(data: [DataType]) async throws
    
    func clear() async throws
}
