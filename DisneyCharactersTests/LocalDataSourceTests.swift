//
//  DisneyCharactersTests.swift
//  DisneyCharactersTests
//
//  Created by George McDonnell on 26/03/2023.
//

import XCTest
@testable import DisneyCharacters

final class LocalDataSourceTests: XCTestCase {

    private let persistence = PersistenceController(inMemory: true)
    
    private var sut: CoreDataStore!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = CoreDataStore(container: persistence.container)
        try await sut.add(data: [DisneyCharacter.mock()])
    }

    func testInsert() async {
        do {
            try await sut.add(data: [DisneyCharacter.mock2()])
            let results = try await sut.readData().get()
            XCTAssert(results.count == 2)
        } catch {
            XCTFail()
        }
    }
    
    func testRead() async {
        do {
            let results = try await sut.readData().get()
            guard let result = results.first else {
                XCTFail()
                return
            }
            XCTAssertEqual(result, DisneyCharacter.mock())
        } catch {
            XCTFail()
        }
    }
    
    func testClear() async {
        do {
            let results = try await sut.readData().get()
            guard let _ = results.first else {
                XCTFail()
                return
            }
            try await sut.clear()
            let read = try await sut.readData().get()
            XCTAssertEqual([], read)
        } catch {
            XCTFail()
        }
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        
        try await sut.clear()
    }
}

extension DisneyCharacter {
    static func mock() -> DisneyCharacter {
        return DisneyCharacter(name: "Test", imageUrl: nil, films: ["Film 1"], shortFilms: ["Short Film 1"], parkAttractions: ["Park attraction 1", "Park attraction 1"])
    }
    static func mock2() -> DisneyCharacter {
        return DisneyCharacter(name: "Test2", imageUrl: nil, films: ["Film 2"], shortFilms: ["Short film 1"], parkAttractions: ["Park attraction 2"])
    }
    static func mock3() -> DisneyCharacter {
        return DisneyCharacter(name: "Test3", imageUrl: nil, films: ["Film 2", "Film 3", "Film 4"], shortFilms: ["Short film 1"], parkAttractions: ["Park attraction 3"])
    }
    static func mock4() -> DisneyCharacter {
        return DisneyCharacter(name: "Test4", imageUrl: nil, films: ["Film 4", "Film 4"], shortFilms: [], parkAttractions: [])
    }
    static func mock5() -> DisneyCharacter {
        return DisneyCharacter(name: "Test5", imageUrl: nil, films: [], shortFilms: ["Short film 1"], parkAttractions: [])
    }
    static func mock6() -> DisneyCharacter {
        return DisneyCharacter(name: "Test6", imageUrl: nil, films: [], shortFilms: [], parkAttractions: [])
    }
}
