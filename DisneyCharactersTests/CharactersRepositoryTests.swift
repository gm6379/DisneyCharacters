//
//  CharacterRepositoryTests.swift
//  DisneyCharactersTests
//
//  Created by George McDonnell on 26/03/2023.
//

import Foundation

import XCTest
@testable import DisneyCharacters

final class CharactersRepositoryTests: XCTestCase {
    
    private let local = MockLocalDataSource()
    private let remote = MockRemoteDataSource()
    private let kv = MockKeyValueStore()
    var sut: CharactersRepository!
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = CharactersRepositoryImpl(
            remoteDataSource: remote,
            localDataSource: local,
            settingStore: kv,
            pageSize: 2
        )
    }
    
    func testGetCharactersReturnsOrderedPage() async {
        let expected = Page(characters: [.mock3(), .mock()], number: 1, hasNextPage: true, hasPreviousPage: false)
        let page = try! await sut.getCharacters(page: 1).get()
        XCTAssertEqual(expected, page)
    }
    
    func testGetCharactersReturnsOrderedPage2() async {
        let expected = Page(characters: [.mock2(), .mock4()], number: 2, hasNextPage: true, hasPreviousPage: true)
        let page = try! await sut.getCharacters(page: 2).get()
        XCTAssertEqual(expected, page)
    }
    
    func testGetCharactersReturnsOrderedPage3() async {
        let expected = Page(characters: [.mock5(), .mock6()], number: 3, hasNextPage: false, hasPreviousPage: true)
        let page = try! await sut.getCharacters(page: 3).get()
        XCTAssertEqual(expected, page)
    }
    
    func testAboveRangePageReturnsError() async {
        do {
            _ = try await sut.getCharacters(page: 4).get()
            XCTFail()
        } catch {}
    }
    
    func testLessThanRangePageReturnsError() async {
        do {
            _ = try await sut.getCharacters(page: 0).get()
            XCTFail()
        } catch {}
    }
    
}
