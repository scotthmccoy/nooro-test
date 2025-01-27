
import Foundation

// RepositoryDataProvider encapsulates the process of fetching data from the bundle, an API, or
// some hardcoded results that are useful for supporting Previews.
// This allows the Repository to not have to concern itself with how that gets done.

enum RepositoryDataProviderSource {
    /// Hits the live API
    case live
    /// Fetches from exploreData.json
    case mainBundleTestData
    /// Always returns an empty set
    case empty
    /// Always returns an error
    case alwaysFail
}


enum RepositoryDataProviderError: Error, Equatable {
    case noPath
    case dataFetchingError(String)
    case codableHelperError(CodableHelperError)
    case apiError(WeatherApiError)
}


protocol RepositoryDataProviderProtocol: Sendable {
    func search(string: String) async -> Result<[SearchResult], RepositoryDataProviderError>
}


final class RepositoryDataProvider: RepositoryDataProviderProtocol {

    let repositoryDataProviderSource: RepositoryDataProviderSource
    let weatherApi: WeatherApiProtocol
    
    init(
        _ repositoryDataProviderSource: RepositoryDataProviderSource,
        weatherApi: WeatherApiProtocol = WeatherApi.singleton
    ) {
        self.repositoryDataProviderSource = repositoryDataProviderSource
        self.weatherApi = weatherApi
    }
    
    func search(string: String) async -> Result<[SearchResult], RepositoryDataProviderError> {

        switch repositoryDataProviderSource {
            case .live:
                return await self.weatherApi
                    .search(
                        string: string
                    )
                    .mapError {
                        .apiError($0)
                    }
                
            case .mainBundleTestData:
                
                // Make a file URL
                guard let path = Bundle.main.path(forResource:"exploreData.json", ofType: nil) else {
                    return .failure(.noPath)
                }
                let url = URL(fileURLWithPath: path)

                // Pass it to the API
                return await self.weatherApi
                    .search(url: url, string: string)
                    .mapError {
                        // Wrap in
                        .apiError($0)
                    }

            case .empty:
                return .success([])
                
            case .alwaysFail:
                return .failure(.noPath)
        }
    }
}


