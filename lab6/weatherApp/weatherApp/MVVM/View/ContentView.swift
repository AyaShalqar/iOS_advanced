//
//  ContentView.swift
//  weatherApp
//
//  Created by Aknur Seidazym on 08.04.2025.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: WeatherViewModel
    @State private var searchText = ""
    
    init(apiKey: String) {
        let weatherService = WeatherService(apiKey: apiKey)
        _viewModel = StateObject(wrappedValue: WeatherViewModel(weatherService: weatherService))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Search bar
                        searchBar
                        
                        // Error message if any
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(10)
                        }
                        
                        // Weather cards
                        currentWeatherCard
                        weatherDetailsCard
                        forecastCard
                    }
                    .padding()
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
            .navigationTitle("Weather")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await viewModel.refresh()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                            .disabled(viewModel.isRefreshing)
                    }
                }
            }
            .task {
                // Initial data loading
                await viewModel.loadAllWeatherData()
            }
        }
    }
    
    // Search bar
    private var searchBar: some View {
        HStack {
            TextField("Enter city name", text: $searchText)
                .padding(8)
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
                .submitLabel(.search)
                .onSubmit {
                    Task {
                        await viewModel.updateCity(searchText)
                        searchText = ""
                    }
                }
            
            Button {
                Task {
                    await viewModel.updateCity(searchText)
                    searchText = ""
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
            }
        }
    }
    
    // Current weather card
    private var currentWeatherCard: some View {
        Group {
            switch viewModel.currentWeatherState {
            case .idle:
                EmptyView()
                
            case .loading:
                ProgressView("Loading weather...")
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                
            case .success(let weather):
                VStack(spacing: 16) {
                    // City name and date
                    HStack {
                        Text(weather.name + ", " + weather.sys.country)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(viewModel.formatDate(weather.dt))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Current weather
                    HStack(spacing: 20) {
                        // Weather icon and description
                        if let condition = weather.weather.first {
                            VStack {
                                Image(systemName: viewModel.getWeatherIcon(condition.icon))
                                    .font(.system(size: 60))
                                    .foregroundColor(.blue)
                                
                                Text(condition.description.capitalized)
                                    .font(.headline)
                            }
                        }
                        
                        Spacer()
                        
                        // Temperature
                        VStack(alignment: .trailing) {
                            Text(viewModel.formatTemperature(weather.main.temp))
                                .font(.system(size: 42, weight: .bold))
                            
                            Text("Feels like: \(viewModel.formatTemperature(weather.main.feels_like))")
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
                
            case .failure:
                Text("Failed to load weather data")
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
            }
        }
    }
    
    // Weather details card
    private var weatherDetailsCard: some View {
        Group {
            switch viewModel.currentWeatherState {
            case .success(let weather):
                VStack(alignment: .leading, spacing: 16) {
                    Text("Weather Details")
                        .font(.headline)
                    
                    // Weather details grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        DetailItem(icon: "thermometer", title: "Min Temp", value: viewModel.formatTemperature(weather.main.temp_min))
                        DetailItem(icon: "thermometer", title: "Max Temp", value: viewModel.formatTemperature(weather.main.temp_max))
                        DetailItem(icon: "humidity", title: "Humidity", value: "\(weather.main.humidity)%")
                        DetailItem(icon: "gauge", title: "Pressure", value: "\(weather.main.pressure) hPa")
                        DetailItem(icon: "wind", title: "Wind Speed", value: "\(Int(weather.wind.speed * 3.6)) km/h")
                        DetailItem(icon: "arrow.up", title: "Wind Direction", value: "\(weather.wind.deg)°")
                        DetailItem(icon: "cloud", title: "Cloudiness", value: "\(weather.clouds.all)%")
                        DetailItem(icon: "sunrise", title: "Sunrise", value: viewModel.formatTime(weather.sys.sunrise))
                        DetailItem(icon: "sunset", title: "Sunset", value: viewModel.formatTime(weather.sys.sunset))
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
                
            default:
                EmptyView()
            }
        }
    }
    
    // Forecast card
    private var forecastCard: some View {
        Group {
            switch viewModel.forecastState {
            case .idle:
                EmptyView()
                
            case .loading:
                ProgressView("Loading forecast...")
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                
            case .success(let forecast):
                VStack(alignment: .leading, spacing: 16) {
                    Text("5-Day Forecast")
                        .font(.headline)
                    
                    // Group forecast by day
                    ForEach(groupForecastByDay(forecast.list), id: \.0) { day, items in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(day)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(items, id: \.dt) { item in
                                        VStack(spacing: 8) {
                                            Text(viewModel.formatTime(item.dt))
                                                .font(.caption)
                                            
                                            if let condition = item.weather.first {
                                                Image(systemName: viewModel.getWeatherIcon(condition.icon))
                                                    .font(.system(size: 20))
                                            }
                                            
                                            Text(viewModel.formatTemperature(item.main.temp))
                                                .font(.headline)
                                        }
                                        .padding(8)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            
                            Divider()
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
                
            case .failure:
                Text("Failed to load forecast data")
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
            }
        }
    }
    
    // Helper function to group forecast by day
    private func groupForecastByDay(_ forecasts: [ForecastItem]) -> [(String, [ForecastItem])] {
        let grouped = Dictionary(grouping: forecasts) { item in
            viewModel.getDayFromTimestamp(item.dt)
        }
        
        return grouped.sorted { day1, day2 in
            let today = viewModel.getDayFromTimestamp(Int(Date().timeIntervalSince1970))
            
            // If today is one of the days, it should come first
            if day1.key == today { return true }
            if day2.key == today { return false }
            
            // Otherwise sort by days of week
            let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
            guard let index1 = days.firstIndex(of: day1.key),
                  let index2 = days.firstIndex(of: day2.key) else {
                return day1.key < day2.key
            }
            
            return index1 < index2
        }
    }
}

// Helper view for weather details
struct DetailItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

