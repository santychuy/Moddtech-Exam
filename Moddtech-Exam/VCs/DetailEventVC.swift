//
//  DetailEventVC.swift
//  Moddtech-Exam
//
//  Created by Jesus Santiago Carrasco Campa on 8/22/19.
//  Copyright © 2019 Techson. All rights reserved.
//

import UIKit

class DetailEventVC: UIViewController {

    var concertInfo: ConcertInfo? {
        didSet{
            guard let unwrappedInfo = concertInfo else {return}
            navigationItem.title = unwrappedInfo.name
        }
    }
    
    @IBOutlet weak var imgViewArtist: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgViewArtist.layer.cornerRadius = self.imgViewArtist.frame.size.width/2
        
        //For render the image of the specific URL get it from the concertInfo
        //Check how works inside Services Folder
        ImageService.getImg(withURL: concertInfo!.imgURL) { (imgRes) in
            self.imgViewArtist.image = imgRes
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        navigationItem.largeTitleDisplayMode = .always
    }
    
    //TODO: Add a WebView to display the page inside the app and don't leave the app
    @IBAction func btnTicketsSite(_ sender: Any) {
        guard let url = URL(string: concertInfo!.urlTicket) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    

}
