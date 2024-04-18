//
//  LocalDataSource.swift
//  DisneyCharacters
//
//  Created by George McDonnell on 25/03/2023.
//

import Foundation
import CoreData

enum StoreError: Error {
    case insertFailed(String)
    case fetchFailed(String)
    case deleteFailed(String)
}

actor CoreDataStore: MutableDataSource {
    
    typealias DataType = DisneyCharacter
    
    private let container: NSPersistentContainer
    
    private let characterEntity = "CharacterMO"
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func add(data: [DataType]) async throws {
        try await container.performBackgroundTask { context in
            for character in data {
                guard let managedCharacter = NSEntityDescription.insertNewObject(forEntityName: self.characterEntity, into: context) as? CharacterMO else {
                    throw StoreError.insertFailed("Failed to insert characters")
                }
                managedCharacter.name = character.name
                managedCharacter.attractions = character.parkAttractions
                managedCharacter.shortFilms = character.shortFilms
                managedCharacter.films = character.films
                
                if character.imageUrl != nil {
                    managedCharacter.imageUrl = character.imageUrl
                }
                
            }
            try context.save()
        }
    }
    
    func readData() async -> Result<[DataType], Error> {
        await container.performBackgroundTask { context in
            do {
                let request = NSFetchRequest<CharacterMO>(entityName: self.characterEntity)
                let characters: [DisneyCharacter] = try context.fetch(request)
                    .compactMap { managedCharacter in
                        guard let name = managedCharacter.name,
                              let films = managedCharacter.films,
                              let shortFilms = managedCharacter.shortFilms,
                              let attractions = managedCharacter.attractions else {
                            return nil
                        }
                        return DisneyCharacter(name: name,
                                               imageUrl: managedCharacter.imageUrl,
                                               films: films,
                                               shortFilms: shortFilms,
                                               parkAttractions: attractions)
                    }
                return .success(characters)
            } catch {
                return .failure(StoreError.fetchFailed("Unable to fetch characters"))
            }
        }
    }

    func clear() async throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: characterEntity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try await container.performBackgroundTask { context in
            do {
                try self.container.persistentStoreCoordinator.execute(deleteRequest, with: context)
            } catch let error as NSError {
                throw StoreError.deleteFailed(error.localizedDescription)
            }
        }
    }
}
