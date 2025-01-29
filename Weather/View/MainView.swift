//
//  ContentView.swift
//  Weather
//
//  Created by Scott McCoy on 1/27/25.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = ViewModel()
    
    
    
    var body: some View {
        VStack {
            HStack {
                TextField(
                    "Search Location",
                    text: $viewModel.searchString
                )
                Image(systemName: "magnifyingglass") // Icon
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(
                    cornerRadius: 18)
                .fill(Color.textFieldBackground)
            )
            .foregroundColor(.black)
            .padding()
            
            if let errorMessage = viewModel.errorMessage {
                show(errorMessage: errorMessage)
            } else if viewModel.weathers.count > 0 {
                searchResultsScrollView
            } else if let selectedWeather = viewModel.selectedWeather {
                SelectedWeatherView(weather: selectedWeather)
                Spacer()
            } else {
                pleaseSearchForACity
            }
            
        }
        .padding()
    }
    
    @ViewBuilder
    var searchResultsScrollView: some View {
        ScrollView {
            ForEach(viewModel.weathers, id: \.self) { weather in
                SearchResultRowView(weather: weather)
                    .onTapGesture {
                        viewModel.select(weather: weather)
                    }
            }
        }
    }

    @ViewBuilder
    var pleaseSearchForACity: some View {
        Spacer()
        Text("No City Selected")
            .font(
                .custom(
                    CustomFont.poppinsSemiBold.internalName,
                    size: 30
                )
            )
        Text("Please Search For A City")
            .font(
                .custom(
                    CustomFont.poppinsSemiBold.internalName,
                    size: 17
                )
            )
        Spacer()
    }
    
    func show(errorMessage: String) -> some View {
        VStack {
            Text("Network Error")
                .font(.largeTitle)
            Button("Try Again") {
                viewModel.btnTryAgainTapped()
            }
            ScrollView {
                Text("Error message: \(errorMessage)")
                    .font(.footnote)
                    .padding(20)
            }
            .frame(maxHeight: 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MainView(
        viewModel: ViewModel(
            repository: Repository(
                repositoryDataProvider: RepositoryDataProvider(
                    .mainBundleTestData
                )
            )
        )
    )
}
