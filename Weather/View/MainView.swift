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
            .padding() // Adds padding inside the Text
            .background(
                RoundedRectangle(
                    cornerRadius: 18)
                
                
                .fill(Color.textFieldBackground) // Background color
            )
            .foregroundColor(.black) // Text color
            .padding()
            
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
        .padding()
    }
}

#Preview {
    MainView()
}
