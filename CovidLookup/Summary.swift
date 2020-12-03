//
//  Summary.swift
//  CovidLookup
//
//  Created by Alex Paul on 12/3/20.
//

import Foundation

// create a SummaryWrapper and Country  model

// coverting JSON to Swift objects
// Decodable is part the Codable protocol alias
// typealias  Codable = Encodable & Decodable
struct SummaryWrapper: Codable {
  let countries: [Summary]
  
  // CodingKeys allows us to rename properties
  enum CodingKeys: String, CodingKey {
    case countries = "Countries"
  }
}

struct Summary: Codable {
  let country: String
  let totalConfirmed: Int
  let totalRecovered: Int
  
  enum CodingKeys: String, CodingKey {
    case country = "Country"
    case totalConfirmed = "TotalConfirmed"
    case totalRecovered = "TotalRecovered"
  }
}
