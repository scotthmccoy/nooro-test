//
//  SearchResultRowView.swift
//  Weather
//
//  Created by Scott McCoy on 1/27/25.
//

import SwiftUI

struct SearchResultRowView: View {
    
    let weather: Weather
    
    var body: some View {
        HStack {
            
            VStack {
                HStack {
                    Text(weather.name)
                        .font(
                            .custom(
                                CustomFont.poppinsSemiBold.internalName,
                                size: 20
                            )
                        )
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
                

                HStack {
                    Text("\(weather.temperature)°")
                        .font(
                            .custom(
                                CustomFont.poppinsSemiBold.internalName,
                                size: 50
                            )
                        )
                        .lineLimit(1)
                    Spacer()
                }
                    
            }
            
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
            

        }
        .padding(.leading, 30)
        .padding(.trailing, 30)
        .padding(.top, 20)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        
        .background(
            RoundedRectangle(
                cornerRadius: 18)
            .fill(Color.textFieldBackground)
        )
    }
    
}


#Preview {
    ScrollView {
        SearchResultRowView(
            weather: Weather.stub
        )
        SearchResultRowView(
            weather: Weather.stub
        )
        SearchResultRowView(
            weather: Weather.stub
        )
    }
    .padding(10)
}
