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
        
//        HeroBanner.getWeather(completion: {
//            string in
//        })
    }
    
    static func handleFetchedData(_ data : String){
        
    }
    
    //  Hero Banner data
    static func fetchBanner(completion : @escaping ([HeroBanner])->Void) {
        getWeather(completion: {
            tempValue in
            let banners = [
                HeroBanner(temperature: "", featuredImage: UIImage(named: "stuAddTrainingBox")!),
                HeroBanner(temperature: "\(tempValue)", featuredImage: UIImage(named: "weatherBox")!)
            ]
            completion(banners)
        })
    }
    
    static func getWeather( completion : @escaping ((String) -> Void)) {
        
        var TempValue : String = ""
        
        if let url = URL(string: "https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread&lang=en") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                let decoder = JSONDecoder()
                if let weatherInfo = try? decoder.decode(WeatherInfo.self, from: data!){
                    for TempRecord in weatherInfo.temperature.data where TempRecord.place == "Sham Shui Po" {
                        TempValue = "\(TempRecord.value) °\(TempRecord.unit)"
//                        print("\(TempRecord.value) °\(TempRecord.unit)")

//                        print(TempValue)
                        completion(TempValue)
                    }
                }
            }.resume()
        }
    }
        
}

class WeatherInfo : Codable {
    var temperature : Temperature
    var rainfall : Rainfall
}
class Rainfall : Codable {
    var data : [RainRecord]
}
class RainRecord : Codable {
    var unit : String
    var place : String
    var max : Double
    var main : String
}
class Temperature : Codable {
    var data : [TempRecord]
}
class TempRecord : Codable {
    var place : String
    var value : Double
    var unit  : String
}
