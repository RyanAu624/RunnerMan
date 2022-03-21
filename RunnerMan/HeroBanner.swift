//
//  HeroBanner.swift
//  RunnerMan
//
//  Created by Long Hei Au on 18/3/2022.
//

import UIKit

class HeroBanner {
    
    var stuHome: StudentHomeTableViewController!
    
    var featuredImage: UIImage
    var temperature = ""
    
    init(temperature: String, featuredImage: UIImage) {
        self.temperature = temperature
        self.featuredImage = featuredImage
        
        getWeather()
    }
    
    //  Hero Banner data
    static func fetchBanner() -> [HeroBanner] {
        return [
            HeroBanner(temperature: "", featuredImage: UIImage(named: "stuAddTrainingBox")!),
            HeroBanner(temperature: "25%%%", featuredImage: UIImage(named: "weatherBox")!)
        ]
    }
    
    func getWeather() -> String {
        
        var TempValue : String = ""
        
        if let url = URL(string: "https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread&lang=en") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                let decoder = JSONDecoder()
                if let weatherInfo = try? decoder.decode(WeatherInfo.self, from: data!){
                    for TempRecord in weatherInfo.temperature.data where TempRecord.place == "Sham Shui Po" {
                        TempValue = "\(TempRecord.value) °\(TempRecord.unit)"
//                        print("\(TempRecord.value) °\(TempRecord.unit)")

//                        print(TempValue)
                    }
                }
            }.resume()
        }
        return TempValue
    }
        
}

class WeatherInfo : Codable {
    var temperature : Temperature
}
class Temperature : Codable {
    var data : [TempRecord]
}
class TempRecord : Codable {
    var place : String
    var value : Double
    var unit  : String
}
