import Foundation

struct Weather {
    let dateText: String
    let timeText: String
    let temperature: String
    let humidity: String
}

class WeatherViewModel: ObservableObject {
    @Published var weather: Weather?
    @Published var error: Error?

    func fetchWeather() {
        let serviceKey = "YOUR_SERVICE_KEY" // Replace with your API key
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH00"
        let baseDate = dateFormatter.string(from: now)
        let baseTime = timeFormatter.string(from: now)
        let urlString = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey=\(serviceKey)&pageNo=1&numOfRows=60&dataType=JSON&base_date=\(baseDate)&base_time=\(baseTime)&nx=98&ny=76"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.error = error
                    return
                }

                guard let data = data else { return }
                do {
                    if let weather = try Self.parseWeather(from: data) {
                        self?.weather = weather
                    }
                } catch {
                    self?.error = error
                }
            }
        }
        task.resume()
    }

    private static func parseWeather(from data: Data) throws -> Weather? {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let response = json?["response"] as? [String: Any],
              let body = response["body"] as? [String: Any],
              let items = body["items"] as? [String: Any],
              let itemArray = items["item"] as? [[String: Any]] else { return nil }

        var temp: String?
        var humidity: String?
        var dateText = ""
        var timeText = ""

        for item in itemArray {
            if let category = item["category"] as? String,
               let value = item["obsrValue"] as? String {
                if category == "T1H" {
                    temp = value
                } else if category == "REH" {
                    humidity = value
                }
                if let baseDate = item["baseDate"] as? String,
                   let baseTime = item["baseTime"] as? String {
                    dateText = baseDate
                    timeText = baseTime
                }
            }
        }

        if let t = temp, let h = humidity {
            return Weather(dateText: dateText, timeText: timeText, temperature: t, humidity: h)
        }
        return nil
    }
}
