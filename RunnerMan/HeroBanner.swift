//
//  HeroBanner.swift
//  RunnerMan
//
//  Created by Long Hei Au on 18/3/2022.
//

import UIKit

class HeroBanner {
    
    var featuredImage: UIImage
    var temperature = ""
    
    init(temperature: String, featuredImage: UIImage) {
        self.temperature = temperature
        self.featuredImage = featuredImage
    }
    
//  Hero Banner data
    static func fetchBanner() -> [HeroBanner] {
        return [
            HeroBanner(temperature: "", featuredImage: UIImage(named: "stuAddTrainingBox")!),
            HeroBanner(temperature: "25%", featuredImage: UIImage(named: "weatherBox")!)
        ]
    }
}
