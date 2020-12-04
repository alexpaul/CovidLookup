//
//  APIClient.swift
//  CovidLookup
//
//  Created by Alex Paul on 12/3/20.
//

import Foundation

struct APIClient {
  // communicate retrieved data back to
  // the view controller that made the call
  // ways in which we can communicate:
  // 1. closure, completion handler, callbacks
  // 2. notification center
  // 3. delegation
  // 4. combine
  
  // URLSession is an asychronous API
  // synchronous code blocks UI
  // asynchrouus does not block the main thread, performs request on a background thread
  func fetchCovidData(completion: @escaping (Result<[Summary], Error>) -> ()) {
    // 1. - endpoint URL string
    let endpointURLString = "https://api.covid19api.com/summary"
    
    // 2. - convert the string to an URL
    guard let url = URL(string: endpointURLString) else {
      print("bad url")
      return
    }
    
    // URL vs URLRequest
    
    // 3. - make the request using URLSession
    // .shared is an singleton instance on URLSession comes with basic configuration needed for most requests
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        return completion(.failure(error))
      }
      
      // first we have to type cast URLResponse to HTTPURLRepsonse to get access to the status code
      // we verify the that status code is in the 200 range which signals all went well with the GET request
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("bad status code")
        return
      }
      
      if let jsonData = data {
        // convert data to our swift model
        do {
          let countries = try JSONDecoder().decode(SummaryWrapper.self, from: jsonData).countries
          completion(.success(countries))
        } catch {
          // decoding error
          completion(.failure(error))
        }
      }
    }
    dataTask.resume()
  }
}

