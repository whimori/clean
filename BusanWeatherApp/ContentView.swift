import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        VStack(spacing: 16) {
            if let weather = viewModel.weather {
                Text("\(weather.dateText) \(weather.timeText)")
                    .font(.headline)
                Text("Temperature: \(weather.temperature)°C")
                    .font(.title)
                Text("Humidity: \(weather.humidity)%")
                    .font(.subheadline)
            } else if let error = viewModel.error {
                Text("Failed to load: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear {
            viewModel.fetchWeather()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
