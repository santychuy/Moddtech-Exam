//
//  SearchArtistTVC.swift
//  Moddtech-Exam
//
//  Created by Jesus Santiago Carrasco Campa on 8/22/19.
//  Copyright © 2019 Techson. All rights reserved.
//

import UIKit
import Alamofire

class SearchEventTVC: UITableViewController {

    fileprivate let publicKey = "w2iW9gjniOPWBAdQVkHZv8xzs4WjqgCZ"
    let cellId = "artistID"
    
    //When we get the all the data, will reload the TableView
    var concerts = [ConcertInfo]() {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var searchConcert = [ConcertInfo]()
    
    //Config SearchController
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search by Artist"
        return searchController
    }()
    
    //Store the indexPath when select an artist to have the specific artist
    var indexSelected = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        
        setupNavBar()
        getArtists()
    }
    
    //When leaves this view, will restart to the original data stored
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        searchConcert = concerts
        tableView.reloadData()
    }
    
    private func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Home"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //TODO: Clean and do this func better
    //Pull all the artist available and store it using the library Alamofire for HTTP Requests
    //Then filter the events that are concerts and store it
    private func getArtists() {
        
        //Try API on the browser
        let urlRoot = "https://app.ticketmaster.com/discovery/v2/attractions.json?apikey=\(publicKey)"
        
        Alamofire.request(urlRoot, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (res) in
            guard let json = res.result.value as? [String:Any] else {return}
            guard let inside = json["_embedded"] as? [String:Any] else {return}
            guard let attraction = inside["attractions"] as? [[String:Any]] else {return}
            
            for actor in attraction{
                guard let name = actor["name"] as? String else {return}
                guard let id = actor["id"] as? String else {return}
                guard let urlTicket = actor["url"] as? String else {return}
                guard let classif = actor["classifications"] as? [[String:Any]] else {return}
                guard let imgs = actor["images"] as? [[String:Any]] else {return}
                
                guard let img = imgs[0] as? [String:Any] else {return}
                guard let urlImgString = img["url"] as? String else {return}
                guard let urlImg = URL(string: urlImgString) else {return}
                
                for segment in classif{
                    guard let seg = segment["segment"] as? [String:String] else {return}
                    guard let segName = seg["name"] else {return}
                    
                    //Filter
                    if segName == "Music" {
                        let concert = ConcertInfo(name: name, id: id, urlTicket: urlTicket, imgURL: urlImg)
                        self.concerts.append(concert)
                        self.searchConcert = self.concerts
                    }
                }
                
            }
        }
        
    }
    
    //Pass info of artist to more details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let concertInfo = searchConcert[indexSelected.row]
        if segue.identifier == "segueDetails"{
            let vc = segue.destination as! DetailEventVC
            vc.concertInfo = concertInfo
        }
    }

}



