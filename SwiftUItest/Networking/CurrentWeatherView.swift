//
//  CurrentWeatherView.swift
//  SwiftUItest
//
//  Created by Kaikai Liu on 3/20/20.
//  Copyright © 2020 CMPE277. All rights reserved.
//

import SwiftUI

struct CurrentWeatherView: View {
    @ObservedObject var viewModel: CurrentWeatherViewModel

    init(viewModel: CurrentWeatherViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            List(content: content)
                .onAppear(perform: viewModel.refresh)
                .navigationBarTitle(viewModel.city)
                .listStyle(GroupedListStyle())
        }
    
    }
}

//New added for current weather view
private extension CurrentWeatherView {
    func content() -> some View {
        if let currentviewModel = viewModel.dataSource {
            return AnyView(details(for: currentviewModel))
        } else {
            return AnyView(loading)
        }
    }
    
    func details(for viewModel: CurrentWeatherRowViewModel) -> some View {
        CurrentWeatherRow(viewModel: viewModel)
    }
    
    var loading: some View {
        Text("Loading \(viewModel.city)'s weather...")
            .foregroundColor(.gray)
    }
}

struct CurrentWeatherRow: View {
    private let viewModel: CurrentWeatherRowViewModel
    
    init(viewModel: CurrentWeatherRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
              Image(systemName: viewModel.conditionName)
                  .resizable()
                .frame(width: CGFloat(40), height: CGFloat(40))
              Text(viewModel.name)
              .font(.title)
              .fontWeight(.light)
            }
            Text(viewModel.weatherDescription.capitalized)
              .font(.caption)
              .fontWeight(.light)
            HStack {
                Text("\(viewModel.temperature)°")
                .font(.system(size: 50))
                .fontWeight(.ultraLight)
                
                VStack(alignment: .leading) {
                HStack {
                  Text("🌎 Feels like:")
                  Spacer()
                  Text("\(viewModel.feelsLike)°")
                }.padding(.bottom, 1)
                HStack {
                    Text("📈 Max temperature:")
                    Spacer()
                    Text("\(viewModel.maxTemperature)°")
                    }.padding(.bottom, 1)
                
                HStack {
                    Text("📉 Min temperature:")
                    Spacer()
                    Text("\(viewModel.minTemperature)°")
                    }.padding(.bottom, 1)
                HStack {
                    Text("🌬 Wind speed:")
                    Spacer()
                    Text("\(viewModel.windSpeed) mph")
                }.padding(.bottom, 1)
                HStack {
                    Text("💧 Humidity:")
                    Spacer()
                    Text(viewModel.humidity)
                    }.padding(.bottom, 1)
                }.font(.caption)
            }
            
            MapView(coordinate: viewModel.coordinate)
                .cornerRadius(25)
                .frame(height: 300)
                .disabled(true)
            
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        let currentviewModel = CurrentWeatherViewModel(city: "San Jose", weatherFetcher: DataFetcher())
        return CurrentWeatherView(viewModel: currentviewModel)
    }
}
