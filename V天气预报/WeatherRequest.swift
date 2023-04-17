//
//  WeatherRequest.swift
//  V天气预报
//
//  Created by jianghui on 2023/4/15.
//

import Foundation

class WeatherService {
    
    //the key from https://restapi.amap.com
    private let weatherKey = "186ccbfde42e64bfbc325fe5d1edd11f"
    private let webAPIAddress = "https://restapi.amap.com/v3/weather/weatherInfo"
    
    static let instance = WeatherService()
    
    func getWeather(cityCode: Int) async throws -> [Forecast] {
        let url:String = webAPIAddress +  "?city=\(cityCode)&key=\(weatherKey)&extensions=all"
        guard let weatherUrl = URL(string: url) else {
            fatalError("wrong url")}
        let (data,_) = try await URLSession.shared.data(from: weatherUrl)
        let forecasts = self.parseWeatherJson(data: data)
        return forecasts
    }
    
    //getData
    func getWeather(cityCode: Int, completion:@escaping ((Result<[Forecast],Error>) -> Void)) {
        
        let url:String = webAPIAddress +  "?city=\(cityCode)&key=\(weatherKey)&extensions=all"
        guard let weatherUrl = URL(string: url) else {
            fatalError("wrong url")}
        let request = URLRequest(url: weatherUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response,error) -> Void in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            if let data = data {
                let forecasts = self.parseWeatherJson(data: data)
                DispatchQueue.main.async {
                    completion(.success(forecasts))
                }
            }
        })
        task.resume()
    }
    
    //parse json
    func parseWeatherJson(data: Data) -> [Forecast] {
        let decoder = JSONDecoder()
        var forecasts: [Forecast] = []
        do {
            let container = try decoder.decode(Weather.self, from: data)
            forecasts = container.forecasts
        } catch {
            print(error)
        }
        return forecasts
    }
}
