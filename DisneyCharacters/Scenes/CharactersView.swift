//
//  CharactersView.swift
//  DisneyCharacters
//
//  Created by George McDonnell on 25/03/2023.
//

import SwiftUI
import CoreData

struct CharactersView: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            switch viewModel.viewState {
            case .loading:
                loadingView
            case .error(let error):
                Text(error)
            case .character(let page):
                characterView(page: page)
            }
        }
        .task {
            await viewModel.loadCharacters()
        }
    }
    
    private var loadingView: some View {
        VStack {
            Text("Loading characters...")
            ProgressView()
        }
    }
    
    private func characterView(page: ViewPage) -> some View {
        ScrollView {
            VStack(spacing: 10) {
                HStack {
                    if (page.hasPrevious) {
                        Button("Previous character") {
                            Task {
                                await viewModel.previousPage()
                            }
                        }
                    }
                    Spacer()
                    if (page.hasNext) {
                        Button("Next character") {
                            Task {
                                await viewModel.nextPage()
                            }
                        }
                    }
                }
                
                if let image = page.image, let url = URL(string: image) {
                    AsyncImage(url: url) { image in
                        image.resizable().aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 20, height: 20)
                    }
                }

                Text(page.name)
                
                VStack(alignment: .leading, spacing: 10) {
                    if let films = page.films, !films.isEmpty {
                        Text("Films:\n\(films)")
                    }
                    
                    if let shortFilms = page.shortFilms, !shortFilms.isEmpty {
                        Text("Short Films:\n\(shortFilms)")
                    }
                    
                    if let attractions = page.attractions, !attractions.isEmpty {
                        Text("Park attractions:\n\(attractions)")
                    }
                }
            }.padding()
        }
    }
}
