//
//  ViewModel.swift
//  Weather
//
//  Created by Scott McCoy on 1/27/25.
//


import Foundation
import Combine
import SwiftUI

@MainActor
class ViewModel: ObservableObject {
    
    @Published var searchString = "" {
        didSet {
            taskDebouncer.debounce(delay: 1.0) {
                AppLog("✅ Finished debounce delay")
                Task {
                    guard await !self.searchString.isEmpty else {
                        return
                    }
                    await self.repository.search(string: self.searchString)
                }
            }
        }
    }
    
    @Published var weathers: [Weather] = []
    @Published private(set) var selectedWeather: Weather? {
        didSet {
            guard let selectedWeather else {
                return
            }
            
            self.appStorageWeatherData = CodableHelper()
                .encode(value: selectedWeather)
                .getSuccessOrLogError()
        }
    }
    @Published var errorMessage: String?
    
    private static let storageKey = "appStorageWeatherData"
    @AppStorage(storageKey) private var appStorageWeatherData: Data?
    
    private let taskDebouncer = TaskDebouncer()
    private var repository: RepositoryProtocol
    private var weathersSubscription: AnyCancellable?
    private var errorMessageSubscription: AnyCancellable?
    
    init(
        repository: RepositoryProtocol = Repository.singleton
    ) {
        self.repository = repository

        // If we have data saved, unpack it and select that weather
        if let appStorageWeatherData,
        let decodedWeather = CodableHelper()
            .decode(
                type: Weather.self,
                from: appStorageWeatherData
            )
            .getSuccessOrLogError() {
            
            self.selectedWeather = decodedWeather
        
            // Update the weather from the API
            Task {
                if let updatedWeather = await self.repository.update(weather: decodedWeather) {
                    self.selectedWeather = updatedWeather
                }
            }
        }
        
        // Listen for updates from repository
        weathersSubscription = repository.weathersPublisher.sink { newValue in
            Task { @MainActor in
                AppLog("\(newValue.count) Weathers: \(newValue)")
                self.weathers = newValue
            }
        }
        
        errorMessageSubscription = repository.errorMessagePublisher.sink { newValue in
            Task { @MainActor in
                AppLog("Error Message: \(String(describing: newValue))")
                self.errorMessage = newValue
            }
        }
    }
    
    func select(weather: Weather) {
        self.searchString = ""
        self.weathers = []
        self.selectedWeather = weather
    }
    
    func btnTryAgainTapped() {
        AppLog()
        Task {
            await self.repository.search(string: self.searchString)
        }
    }
}



