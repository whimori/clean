# BusanWeatherApp

This is a small SwiftUI example that fetches the latest weather for Busan using the Korea Meteorological Administration (KMA) open API and displays it in a simple interface.

## Getting Started

1. Obtain an API key from [data.go.kr](https://www.data.go.kr/).
2. Replace the `YOUR_SERVICE_KEY` placeholder in `WeatherViewModel.swift` with your service key.
3. Open the `BusanWeatherApp` folder with Xcode and build/run the project on iOS 15 or later.

The app queries the `getUltraSrtNcst` endpoint to display temperature and humidity for Busan. The grid coordinates `nx=98` and `ny=76` correspond to Busan.
