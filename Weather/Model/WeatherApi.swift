import Foundation


enum WeatherApiError: Error, Equatable {
    case invalidUrl
    case networkError(NetworkError)
    case codableHelperError(CodableHelperError)
}

protocol WeatherApiProtocol: Sendable {
    func search(string: String) async -> Result<[SearchResult], WeatherApiError>
    func search(url: URL, string: String) async -> Result<[SearchResult], WeatherApiError>
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
    
    func search(string: String) async -> Result<[SearchResult], WeatherApiError> {
        
        guard let escapedSearchString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return .failure(.invalidUrl)
        }
        
        let urlString = await searchBaseUrlString + escapedSearchString
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidUrl)
        }
        
        let urlRequest = URLRequest(url: url)
        
        // Use private method to get search results
        return await get(urlRequest: urlRequest)
    }
    
    // Alternative method. Uses any URL. Useful for loading from the Bundle.
    func search(
        url: URL,
        string: String
    ) async -> Result<[SearchResult], WeatherApiError> {
        
        let urlRequest = URLRequest(url: url)
        
        return await get(urlRequest: urlRequest)
    }
    
    // MARK: - Private
    private func get(
        urlRequest: URLRequest
    ) async -> Result<[SearchResult], WeatherApiError> {
        
        return await network.requestData(
            urlRequest: urlRequest
        ).mapError {
            // Wrap NetworkError
            .networkError($0)
        }.flatMap {
            // Convert Data to Result<APIResponseDataObject, APIError>
            codableHelper.decode(
                type: [SearchResultDataObject].self,
                from: $0
            )
            // Wrap CodableHelperError
            .mapError {
                .codableHelperError($0)
            }
        }
        .map {
            // Convert Data objects to domain objects
            $0.compactMap {
                $0.searchResult
            }
        }

    }
}
