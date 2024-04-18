//
//  Character.swift
//  DisneyCharacters
//
//  Created by George McDonnell on 25/03/2023.
//

import Foundation
import CoreData

struct DisneyCharacter: Codable, Comparable, Equatable {
    let name: String
    let imageUrl: String?
    let films: [String]
    let shortFilms: [String]
    let parkAttractions: [String]
    
    static func < (lhs: DisneyCharacter, rhs: DisneyCharacter) -> Bool {
        return lhs.score < rhs.score
    }
    
    private var score: Int {
        return films.count + shortFilms.count + parkAttractions.count
    }
}

struct Info: Codable {
    let totalPages: Int
}

struct APIPage: Codable {
    let data: [DisneyCharacter]
    let info: Info
}

struct Page: Equatable {
    let characters: [DisneyCharacter]
    let number: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
}
