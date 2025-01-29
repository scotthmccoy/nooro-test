
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
    func search(string: String) async -> Result<[Weather], RepositoryDataProviderError>
    func update(weather: Weather) async -> Result<Weather, RepositoryDataProviderError>
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
    
    func search(string: String) async -> Result<[Weather], RepositoryDataProviderError> {

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
                let weathers = [Weather.stub, Weather.stub]
                return .success(weathers)

            case .empty:
                return .success([])
                
            case .alwaysFail:
                return .failure(.noPath)
        }
    }
    
    func update(weather: Weather) async -> Result<Weather, RepositoryDataProviderError> {
        AppLog("weather: \(weather)")

        return await self.weatherApi
            .search(
                string: weather.locationId
            )
            .mapError {
                .apiError($0)
            }
            .flatMap {
                guard let weather = $0.first(where: {
                    $0.locationId == weather.locationId
                }) else {
                    return .failure(.apiError(.noResults))
                }
                
                return .success(weather)
            }

    }
}


