//
//  CharactersViewModel.swift
//  DisneyCharacters
//
//  Created by George McDonnell on 26/03/2023.
//

import Foundation

enum ViewState {
    case loading
    case character(ViewPage)
    case error(String)
}

struct ViewPage {
    let name: String
    let films: String?
    let shortFilms: String?
    let attractions: String?
    let image: String?
    let hasPrevious: Bool
    let hasNext: Bool
}

extension CharactersView {
    
    class ViewModel: ObservableObject {
        
        private let repository: CharactersRepository
        @Published var viewState: ViewState = .loading
        
        private let dataQuerySize = 10
        private var pageNumber = 1
        private var pageCharacters = [DisneyCharacter]()
        private var totalDataPages: Int = 0
        private var currentDataPage: Page?

        init(repository: CharactersRepository) {
            self.repository = repository
        }
        
        func loadCharacters() async {
            let charactersResult = await repository.getCharacters(page: pageNumber)
            switch charactersResult {
            case .failure(let error):
                await errorState(error: error.localizedDescription)
            case .success(let page):
                currentDataPage = page
                if !page.characters.isEmpty {
                    guard let character = page.characters.first else {
                        await errorState(error: "Unable to load characters")
                        return
                    }
                    await characterState(character: character)
                }
            }
        }
        
        
        func nextPage() async {
            guard let currentDataPage = currentDataPage else {
                return
            }
            if pageNumber == dataQuerySize && currentDataPage.hasNextPage {
                await loadingState()
                let characters = await repository.getCharacters(page: currentDataPage.number + 1)
                switch characters {
                case .failure(let error):
                    await errorState(error: error.localizedDescription)
                case .success(let page):
                    pageNumber = 1
                    self.currentDataPage = page
                    guard let character = page.characters.first else {
                        await errorState(error: "Unable to load characters")
                        return
                    }
                    await characterState(character: character)
                }
            } else {
                pageNumber += 1
                await characterState(character: currentDataPage.characters[pageNumber - 1])
            }
        }
        
        func previousPage() async {
            guard let currentDataPage = currentDataPage else {
                return
            }
            if pageNumber == 1 && currentDataPage.hasPreviousPage {
                await loadingState()
                let characters = await repository.getCharacters(page: currentDataPage.number - 1)
                switch characters {
                case .failure(let error):
                    await errorState(error: error.localizedDescription)
                case .success(let page):
                    pageNumber = dataQuerySize
                    self.currentDataPage = page
                    await characterState(character: page.characters[pageNumber - 1])
                }
            } else {
                pageNumber -= 1
                await characterState(character: currentDataPage.characters[pageNumber - 1])
            }
        }
            
        @MainActor
        private func characterState(character: DisneyCharacter) {
            viewState = .character(
                ViewPage(name: character.name,
                         films: character.films.joined(separator: ", "),
                         shortFilms: character.shortFilms.joined(separator: ", "),
                         attractions: character.parkAttractions.joined(separator: ", "),
                         image: character.imageUrl,
                         hasPrevious: currentDataPage?.hasPreviousPage ?? false || pageNumber > 1 ,
                         hasNext: currentDataPage?.hasNextPage ?? false || pageNumber == dataQuerySize)
            )
        }
        
        @MainActor
        private func loadingState() {
            viewState = .loading
        }
        
        @MainActor
        private func errorState(error: String) {
            viewState = .error(error)
        }
    }
}
