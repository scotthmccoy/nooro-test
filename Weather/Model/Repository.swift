import Foundation

// Repository is the source of truth for the rest of the application and interface to the model layer for ViewModels.
// It is observable, provides Domain objects.

@MainActor
protocol RepositoryProtocol: Sendable {
    var searchResults: [SearchResult] { get }
    var searchResultsPublisher: Published<[SearchResult]>.Publisher { get }
    
    var errorMessage: String? { get }
    var errorMessagePublisher: Published<String?>.Publisher { get }
    
    func search(string: String) async
}


@MainActor
final class Repository: RepositoryProtocol, ObservableObject {
    
    static let singleton = Repository()
    
    @Published var searchResults = [SearchResult]()
    var searchResultsPublisher: Published<[SearchResult]>.Publisher {$searchResults}
    
    @Published var errorMessage: String? = nil
    var errorMessagePublisher: Published<String?>.Publisher {$errorMessage}
    
    private let repositoryDataProvider: RepositoryDataProviderProtocol
    
    // MARK: - init
    init(
        repositoryDataProvider: RepositoryDataProviderProtocol = RepositoryDataProvider(.live)
    ) {
        AppLog()
        self.repositoryDataProvider = repositoryDataProvider
    }


    func search(string: String) async {
        AppLog("string: \(string)")
        let result = await repositoryDataProvider.search(string: string)
        switch result {
            case .success(let searchResults):
                self.searchResults = searchResults
            case .failure(let repositoryDataProviderError):
                self.errorMessage = "\(repositoryDataProviderError)"
        }
    }
}
