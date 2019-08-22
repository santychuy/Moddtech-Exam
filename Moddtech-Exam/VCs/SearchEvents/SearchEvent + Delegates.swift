//
//  SearchEvent + Delegates.swift
//  Moddtech-Exam
//
//  Created by Jesus Santiago Carrasco Campa on 8/22/19.
//  Copyright © 2019 Techson. All rights reserved.
//

import UIKit

extension SearchEventTVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchConcert.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let concert = searchConcert[indexPath.row]
        
        cell.textLabel?.text = concert.name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected = indexPath
        performSegue(withIdentifier: "segueDetails", sender: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension SearchEventTVC: UISearchBarDelegate {
    
    //TODO: Fix when dismiss the SearchView and it's no result, reset the default data, get it at the beggining
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {searchConcert = concerts; tableView.reloadData(); return}
        
        searchConcert = concerts.filter({ (concertRes) -> Bool in
            return concertRes.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
