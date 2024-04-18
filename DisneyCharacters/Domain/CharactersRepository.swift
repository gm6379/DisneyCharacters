//
//  CharactersRepository.swift
//  DisneyCharacters
//
//  Created by George McDonnell on 25/03/2023.
//

import Foundation

protocol CharactersRepository {
    func getCharacters(page: Int) async -> Result<Page, Error>
}

enum RepositoryError: Error {
    case dataError(String)
}

actor CharactersRepositoryImpl<Remote: DataSource, Local: MutableDataSource>: CharactersRepository where Remote.DataType == DisneyCharacter, Local.DataType == DisneyCharacter {
    
    let remoteDataSource: Remote
    let localDataSource: Local
    let settingStore: KeyValueStore
    let pageSize: Int

    private let refreshedKey = "characters_refreshed"
    private let sevenDays: TimeInterval = 3600 * 24 * 7
      
    
    init(remoteDataSource: Remote, localDataSource: Local, settingStore: any KeyValueStore, pageSize: Int) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.settingStore = settingStore
        self.pageSize = pageSize
    }
    
    func getCharacters(page: Int) async -> Result<Page, Error> {
        do {
            let local = try await localDataSource.readData().get()
            if !local.isEmpty && hasExpired {
                try await localDataSource.clear()
            }
            if hasExpired {
                try await refreshData()
                let refreshed = try await localDataSource.readData().get()
                return getPage(characters: refreshed.sorted(by: >), page: page)
            } else {
                return getPage(characters: local.sorted(by: >), page: page)
            }
        } catch {
            return .failure(error)
        }
    }
    
    private func getPage(characters: [DisneyCharacter], page: Int) -> Result<Page, Error> {
        let pages = characters.chunked(into: pageSize)
        if page > pages.count || page <= 0 {
            return .failure(RepositoryError.dataError("Unable to get page \(page)"))
        } else {
            return .success(
                Page(characters: pages[page - 1],
                     number: page,
                     hasNextPage: page < pages.count,
                     hasPreviousPage: page > 1)
            )
        }
    }
    
    private func refreshData() async throws {
        try await localDataSource.add(data: remoteDataSource.readData().get())
        settingStore.set(key: refreshedKey, value: Date())
    }

    private var hasExpired: Bool {
        guard let storeRefreshed: Date = settingStore.get(for: refreshedKey) else {
            return true
        }
        return Date().timeIntervalSince(storeRefreshed) > sevenDays
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
