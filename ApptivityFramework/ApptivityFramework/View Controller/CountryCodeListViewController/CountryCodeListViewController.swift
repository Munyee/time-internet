//
//  CountryCodeListViewController.swift
//  ApptivityFramework
//
//  Created by Avery Choke Kar Sing on 05/03/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

public class CountryCodeListViewController: UIViewController {

    @IBOutlet public weak var tableView: UITableView!
    
    fileprivate enum DisplayMode: Int {
        case countries, search
    }
    fileprivate var displayMode: DisplayMode = .countries
    fileprivate var searchText: String? = nil
    
    fileprivate var searchController: UISearchController!
    fileprivate var countries: [(name: String, isoCountryCode: String)] = []
    fileprivate var searchResults: [(name: String, isoCountryCode: String)] = []
    
    public var completion: ((_ countryCode: String?, _ cancelled: Bool) -> Void)?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .plain, target: self, action: #selector(CountryCodeListViewController.cancel(sender:)))
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        let cellNib: UINib = UINib(nibName: "CountryCodeCell", bundle: Bundle(for: self.classForCoder))
        self.tableView.register(cellNib, forCellReuseIdentifier: "CountryCodeCell")
        
        if let jsonURL: URL = Bundle(for: CountryCodeListViewController.self).url(forResource: "countries", withExtension: "json") {
            do {
                let jsonData: Data = try Data(contentsOf: jsonURL)
                if let countriesJSON: [[String : Any]] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [[String : Any]] {
                    
                    for countryJSON: [String : Any] in countriesJSON {
                        self.countries.append((name: countryJSON["Name"] as! String, isoCountryCode: (countryJSON["Code"] as! String).lowercased()))
                    }
                    let registeredCountries: [(name: String, isoCountryCode: String)] = self.countries.filter({(PhoneCountry.phoneCode(for: $0.isoCountryCode) != nil)})
                    self.countries = registeredCountries
                }
            } catch {
                debugPrint("Failed to load countries list")
            }
        }
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: Any) {
        self.completion?(nil, true)
        self.dismissVC()
    }
}

extension CountryCodeListViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayMode == .countries ? self.countries.count : self.searchResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountryCodeCell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
        
        let country: (name: String, isoCountryCode: String) = self.displayMode == .countries ? self.countries[indexPath.row] : self.searchResults[indexPath.row]
        
        cell.countryLabel.text = country.name
        cell.codeLabel.text = PhoneCountry.phoneCode(for: country.isoCountryCode)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country: (name: String, isoCountryCode: String) = self.displayMode == .countries ? self.countries[indexPath.row] : self.searchResults[indexPath.row]
        self.completion?(PhoneCountry.phoneCode(for: country.isoCountryCode), false)
        self.dismissVC()
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Array(Set(self.countries.map({"\($0.name.first!)"}))).sorted()
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let filteredCountry: (name: String, isoCountryCode: String) = self.countries.filter({$0.name.hasPrefix(title)}).first {
            let row: Int = self.countries.index(where: {$0 == filteredCountry})!
            tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
        return index
    }
}

extension CountryCodeListViewController: UISearchControllerDelegate {
    public func willDismissSearchController(_ searchController: UISearchController) {
        
    }
}

// MARK: - UISearchResultsUpdating
extension CountryCodeListViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchString: String = searchController.searchBar.text {
            if searchString.isEmpty {
                self.displayMode = .countries
                self.tableView.reloadData()
                return
            }
            
            self.searchResults = self.countries.filter({ $0.name.contains(searchString) })
            self.displayMode = .search
            self.tableView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate
extension CountryCodeListViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.text = searchBar.text
        
        // When searchbar resigns, if text is not empty, show search results
        if (self.searchController.searchBar.text ?? "").isEmpty {
            self.displayMode = .countries
        } else {
            self.displayMode = .search
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

// obtain the VC
public extension CountryCodeListViewController {
    public static func countryCodeListVC(completion: ((_ countryCode: String?, _ cancelled: Bool) -> Void)?) -> CountryCodeListViewController {
        var countryCodeListVC: CountryCodeListViewController! = nil
        
        let bundle: Bundle = Bundle(for: CountryCodeListViewController.classForCoder())
        let nib: UINib = UINib(nibName: "CountryCodeListViewController", bundle: bundle)
        for items in nib.instantiate(withOwner: nil, options: nil) {
            if let targetVC: CountryCodeListViewController = items as? CountryCodeListViewController {
                countryCodeListVC = targetVC
                break
            }
        }
        
        countryCodeListVC.completion = completion
        return countryCodeListVC
    }
}
