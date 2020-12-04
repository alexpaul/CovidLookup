//
//  ViewController.swift
//  CovidLookup
//
//  Created by Alex Paul on 12/3/20.
//

import UIKit

class CovidCountriesViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  // instance method vs class or static method
  
  private let apiClient = APIClient()
  
  private var countriesSummary = [CountrySummary]() {
    didSet { // property observer listens for changes on this property
      DispatchQueue.main.async { // we have to update UI on the main thread
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    fetchCovidData()
  }
  
  private func fetchCovidData() {
    apiClient.fetchCovidData { [weak self] (result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let countries):
        self?.countriesSummary = countries
      }
    }
  }
}

extension CovidCountriesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countriesSummary.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
    
    // configure cell
    let countrySummary = countriesSummary[indexPath.row]
    cell.textLabel?.text = countrySummary.country
    cell.detailTextLabel?.text = "Confirmed: \(countrySummary.totalConfirmed) Recovered: \(countrySummary.totalRecovered)"
    
    return cell
  }
}

