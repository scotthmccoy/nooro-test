//
//  SelectedWeatherView.swift
//  Weather
//
//  Created by Scott McCoy on 1/28/25.
//

import SwiftUI

struct SelectedWeatherView: View {
    
    let weather: Weather
    
    var body : some View {
        VStack {
            weatherIcon
            cityAndLocationIcon
            temperature
            weatherStats
        }
        
        
    }
    
    var weatherIcon: some View {
        CachedAsyncImage(url: weather.weatherIconUrl) { phase in
            switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                default:
                    ProgressView()
                        .progressViewStyle(.circular)
            }
        }
        .containerRelativeFrame(.horizontal, count: 2, span: 1, spacing: 0)
    }
    
    var cityAndLocationIcon: some View {
        (
            Text(weather.name + " ")
            .font(
                .custom(
                    CustomFont.poppinsSemiBold.internalName,
                    size: 30
                )
            )
            +
            Text(Image(systemName: "location.fill"))
            .font(
                .custom(
                    CustomFont.poppinsSemiBold.internalName,
                    size: 25
                )
            )
        )
        .multilineTextAlignment(.leading)
        .lineLimit(1)
        .truncationMode(.tail)
    }
    
    var temperature: some View {
        Text("\(weather.temperature)°")
            .font(
                .custom(
                    CustomFont.poppinsSemiBold.internalName,
                    size: 60
                )
            )
            .lineLimit(1)
    }
    
    var weatherStats: some View {
        HStack {
            weatherStat(key: "Humidity", value: "\(weather.humidityPercent)%")
            weatherStat(key: "UV", value: "\(weather.uvIndex)")
            weatherStat(key: "Feels like", value: "\(weather.feelsLikeTemperature)°")
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .containerRelativeFrame(.horizontal, count: 8, span: 6, spacing: 0)
        .background(
            RoundedRectangle(
                cornerRadius: 18)
            .fill(Color.textFieldBackground)
        )
    }
    
    
    @ViewBuilder
    func weatherStat(key: String, value: String) -> some View {
        
        VStack {
            Text(key)
                
                .font(
                    .custom(
                        CustomFont.poppinsRegular.internalName,
                        size: 15
                    )
                )
                .foregroundColor(.weatherStatsKeyTextColor)
                .lineLimit(1)
            
            Text(value)
                .font(
                    .custom(
                        CustomFont.poppinsRegular.internalName,
                        size: 14
                    )
                )
                .foregroundColor(.weatherStatsValueTextColor)
                .lineLimit(1)
        }
        .containerRelativeFrame(.horizontal, count: 5, span: 1, spacing: 0)
        
    }
}


#Preview {
    SelectedWeatherView(weather: Weather.stub)
}
