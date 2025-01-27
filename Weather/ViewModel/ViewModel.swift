//
//  ViewModel.swift
//  Weather
//
//  Created by Scott McCoy on 1/27/25.
//


import Foundation
import Combine

@MainActor
class ViewModel: ObservableObject {
    
    
    
    @Published var searchString = "" {
        didSet {
            taskDebouncer.debounce(delay: 1.0) {
                AppLog("✅ Finished debounce delay")
                Task {
                    await self.repository.search(string: self.searchString)
                }
            }
        }
    }
    
    @Published var searchResults: [SearchResult] = []
    @Published var errorMessage: String?
    
    
    private let taskDebouncer = TaskDebouncer()
    private var repository: RepositoryProtocol
    private var searchResultsSubscription: AnyCancellable?
    private var errorMessageSubscription: AnyCancellable?
    
    init(
        repository: RepositoryProtocol = Repository.singleton
    ) {
        self.repository = repository
        
        // Listen for updates from repository
        searchResultsSubscription = repository.searchResultsPublisher.sink { newValue in
            Task { @MainActor in
                AppLog("Search Results: \(newValue)")
                self.searchResults = newValue
            }
        }
        
        errorMessageSubscription = repository.errorMessagePublisher.sink { newValue in
            Task { @MainActor in
                AppLog("Error Message: \(String(describing: newValue))")
                self.errorMessage = newValue
            }
        }
    }
    
//    func onAppear() {
//        AppLog()
//        Task {
//            await repository.fetch()
//        }
//    }
//    
//    func refresh() {
//        AppLog()
//        Task {
//            await repository.fetch()
//        }
//    }
//    
//    func btnTryAgainTapped() {
//        AppLog()
//        Task {
//            await repository.fetch()
//        }
//    }
}
