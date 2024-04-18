//
//  DisneyCharactersApp.swift
//  DisneyCharacters
//
//  Created by George McDonnell on 25/03/2023.
//

import SwiftUI

@main
struct DisneyCharactersApp: App {
    let persistenceController = PersistenceController.shared
    
    let charactersRepository: CharactersRepository =
        CharactersRepositoryImpl(
            remoteDataSource: RemoteDataSource(),
            localDataSource:
                CoreDataStore(
                    container: PersistenceController.shared.container
                 ),
            settingStore: LocalKeyValueStore(),
            pageSize: 10
        )
    
    var body: some Scene {
        WindowGroup {
            CharactersView(viewModel: .init(repository: charactersRepository))
        }
    }
}
