import Foundation


// Example search URL: https://api.weatherapi.com/v1/search.json?key=b50111d17cbf4389856203421252701&q=Los%20Angeles
// Example current URL: https://api.weatherapi.com/v1/current.json?key=b50111d17cbf4389856203421252701&q=los-angeles-california-united-states-of-america

enum WeatherApiError: Error, Equatable {
    case invalidUrl
    case networkError(NetworkError)
    case codableHelperError(CodableHelperError)
    case couldNotMakeDomainObject
    case noResults
}

protocol WeatherApiProtocol: Sendable {
    func search(string: String) async -> Result<[Weather], WeatherApiError>
    func search(url: URL) async -> Result<[Weather], WeatherApiError>
    
    func getCurrentWeather(locationId: String) async -> Result<Weather, WeatherApiError>
}

final class WeatherApi: WeatherApiProtocol {

    static let singleton = WeatherApi()
    
    @MainActor var searchBaseUrlString = "https://api.weatherapi.com/v1/search.json?key=b50111d17cbf4389856203421252701&q="
    @MainActor var currentWeatherBaseUrlString = "https://api.weatherapi.com/v1/current.json?key=b50111d17cbf4389856203421252701&q="
    
    private let network: NetworkProtocol
    private let codableHelper: CodableHelperProtocol
    
    init(
        network: NetworkProtocol = Network(),
        codableHelper: CodableHelperProtocol = CodableHelper()
    ) {
        self.network = network
        self.codableHelper = codableHelper
    }
    
    func search(string: String) async -> Result<[Weather], WeatherApiError> {
        
        guard let escapedSearchString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return .failure(.invalidUrl)
        }
        
        let urlString = await searchBaseUrlString + escapedSearchString
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidUrl)
        }
        
        return await search(url: url)
    }
    
    func search(url: URL) async -> Result<[Weather], WeatherApiError> {
        let urlRequest = URLRequest(url: url)
        
        // Use private method to get search results
        let result: Result<[SearchResultDataObject], WeatherApiError> = await get(urlRequest: urlRequest)
        
        guard case let .success(searchResultsDataObjects) = result else {
            return .failure(result.error!)
        }
        
        let searchResults = searchResultsDataObjects.compactMap {
            $0.searchResult
        }
        
        // Get Weather objects in parallel
        var weathers = [Weather]()
        await withTaskGroup(of: Result<Weather, WeatherApiError>.self) { group in

            for searchResult in searchResults {
                group.addTask {
                    // TODO: cache responses to reduce API hits
                    await self.getCurrentWeather(locationId: searchResult.locationId)
                }
            }
 
            for await result in group {
                if let weather = result.getSuccessOrLogError() {
                    weathers.append(weather)
                }
            }
        }
        
        return .success(weathers)
    }
    
    
    // Alternative method. Uses any URL. Useful for loading from the Bundle.
    func search(
        url: URL,
        string: String
    ) async -> Result<[SearchResult], WeatherApiError> {
        
        let urlRequest = URLRequest(url: url)
        let result: Result<[SearchResultDataObject], WeatherApiError> = await get(urlRequest: urlRequest)
        
        // Convert to Domain Object
        return result.map {
            $0.compactMap {
                $0.searchResult
            }
        }
    }
    
    func getCurrentWeather(
        locationId: String
    ) async -> Result<Weather, WeatherApiError> {
        
        guard let escapedSearchString = locationId.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else {
            return .failure(.invalidUrl)
        }
        
        let urlString = await currentWeatherBaseUrlString + escapedSearchString
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidUrl)
        }
        
        let urlRequest = URLRequest(url: url)
        let result: Result<CurrentWeatherDataObject, WeatherApiError> = await get(urlRequest: urlRequest)
        
        // Convert to Domain Object
        return result.flatMap {
            guard let currentWeather = $0.weather(locationId: locationId) else {
                return .failure(.couldNotMakeDomainObject)
            }
            return .success(currentWeather)
        }
    }
    
    
    
    
    // MARK: - Private
    private func get<T: Decodable>(
        urlRequest: URLRequest
    ) async -> Result<T, WeatherApiError> {
        
        return await network.requestData(
            urlRequest: urlRequest
        ).mapError {
            // Wrap NetworkError
            .networkError($0)
        }.flatMap {
            AppLog("API Response: \($0.prettyPrintedJSONString)")
            
            return codableHelper.decode(
                type: T.self,
                from: $0
            )
            // Wrap CodableHelperError
            .mapError {
                .codableHelperError($0)
            }
        }
    }
}
