//
//  WeatherKitManager.swift
//  SurfingApp
//
//  Created by Piotr Eliasz on 05/05/2024.
//

import Foundation

@MainActor class WeatherKitManager: ObservableObject {
    @Published var temperature: String = "Loading..."
    @Published var symbol: String = "xmark"

    func getWeather() {
        let apiKey = "e6c61579e131bae84c784239be3c417d"
        let latitude = 20.00
        let longitude = -158.00
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        Task(priority: .userInitiated) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let decodedResponse = try? JSONDecoder().decode(OpenWeatherResponse.self, from: data) {
                    DispatchQueue.main.async {
                        // Convert temperature from Kelvin to Celsius
                        let tempCelsius = decodedResponse.main.temp - 273.15
                        self.temperature = String(format: "%.1f°C", tempCelsius)
                        self.symbol = self.mapSymbol(from: decodedResponse.weather.first?.icon ?? "")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.temperature = "Error decoding response"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.temperature = "Failed to fetch weather: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func mapSymbol(from iconCode: String) -> String {
        switch iconCode {
            case "01d": return "sun.max"
            case "01n": return "moon"
            case "02d", "02n": return "cloud.sun"
            case "03d", "03n": return "cloud"
            case "04d", "04n": return "smoke"
            case "09d", "09n": return "cloud.rain"
            case "10d", "10n": return "cloud.heavyrain"
            case "11d", "11n": return "cloud.bolt"
            case "13d", "13n": return "snow"
            case "50d", "50n": return "cloud.fog"
            default: return "xmark"
        }
    }
}

struct OpenWeatherResponse: Codable {
    struct Main: Codable {
        var temp: Double
    }
    struct Weather: Codable {
        var icon: String
    }
    var main: Main
    var weather: [Weather]
}
