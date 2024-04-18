//
//  RemoteDataSource.swift
//  DisneyCharacters
//
//  Created by George McDonnell on 25/03/2023.
//

import Foundation

enum RemoteStoreError: Error {
    case invalidUrlError(String)
}

struct RemoteDataSource: DataSource {
    
    typealias DataType = DisneyCharacter
    
    private let decoder: JSONDecoder = JSONDecoder()
    
    func readData() async -> Result<[DataType], Error> {
        guard let initialUrl = URL(string: "https://api.disneyapi.dev/character") else {
            return .failure(RemoteStoreError.invalidUrlError("Invalid characters url"))
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: initialUrl)
            let firstPage = try decoder.decode(APIPage.self, from: data)
            if firstPage.info.totalPages == 1 {
                return .success(firstPage.data)
            } else {
                let characters = try await withThrowingTaskGroup(of: (Int, [DisneyCharacter]).self) { group in
                    for page in Array(2 ... firstPage.info.totalPages) {
                        group.addTask {
                            let characters = try await self.characters(at: page)
                            return (page, characters)
                        }
                    }
                    
                    var pagedCharacters = [Int : [DisneyCharacter]]()
                    for try await (page, characters) in group {
                        pagedCharacters[page] = characters
                    }
                    
                    return Array(pagedCharacters.values).flatMap({ $0 })
                }
                return .success(characters)
            }
        } catch {
            return .failure(error)
        }
    }
    
    private func characters(at page: Int) async throws -> [DataType] {
        guard let url = URL(string: "https://api.disneyapi.dev/character?page=\(page)") else {
            throw RemoteStoreError.invalidUrlError("Invalid character pages url")
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode(APIPage.self, from: data).data
    }
}
