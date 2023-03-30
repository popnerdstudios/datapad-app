//
//  Planet.swift
//  Datapad
//
//  Created by Sree Gajula on 3/29/23.
//

import Foundation

struct PlanetData: Codable {
    var data: Planet
}

struct Planet: Codable {
    var name: String
    var description: String
    var imageURL: String
}
