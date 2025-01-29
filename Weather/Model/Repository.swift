import Foundation

// Repository is the source of truth for the rest of the application and interface to the model layer for ViewModels.
// It is observable, provides Domain objects.

@MainActor
protocol RepositoryProtocol: Sendable {
    var weathers: [Weather] { get }
    var weathersPublisher: Published<[Weather]>.Publisher { get }
    
    var errorMessage: String? { get }
    var errorMessagePublisher: Published<String?>.Publisher { get }
    
    func search(string: String) async
    func update(weather: Weather) async -> Weather?
}


@MainActor
final class Repository: RepositoryProtocol, ObservableObject {
    
    static let singleton = Repository()

    // Publishers
    @Published var weathers = [Weather]()
    var weathersPublisher: Published<[Weather]>.Publisher {$weathers}
    
    @Published var errorMessage: String? = nil
    var errorMessagePublisher: Published<String?>.Publisher {$errorMessage}
    
    // Private
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
            case .success(let weathers):
                self.weathers = weathers
            case .failure(let repositoryDataProviderError):
                self.errorMessage = "\(repositoryDataProviderError)"
        }
    }
    
    func update(weather: Weather) async -> Weather? {
        AppLog("weather: \(weather)")

        return await repositoryDataProvider
            .update(weather: weather)
            .getSuccessOrLogError()
    }
}
