//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var Image: UIImageView!
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var Language: UILabel!
    @IBOutlet weak var Stars: UILabel!
    @IBOutlet weak var Watchers: UILabel!
    @IBOutlet weak var Forks: UILabel!
    @IBOutlet weak var Issues: UILabel!

    var viewController1: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let results = viewController1.results[viewController1.idx]
        
        Language.text = "Written in \(results["language"] as? String ?? "")"
        Stars.text = "\(results["stargazers_count"] as? Int ?? 0) stars"
        Watchers.text = "\(results["wachers_count"] as? Int ?? 0) watchers"
        Forks.text = "\(results["forks_count"] as? Int ?? 0) forks"
        Issues.text = "\(results["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
    }
    
    //　ネストを浅くしました
    
    func getImage(){
        let results = viewController1.results[viewController1.idx]
        TitleLabel.text = results["full_name"] as? String
        
        guard let owner = results["owner"] as? [String: Any] else {return}
        guard let imageURL = owner["avatar_url"] as? String else {return}
        
        URLSession.shared.dataTask(with: URL(string: imageURL)!) { (data, response, error) in
            let imageData = UIImage(data: data!)!
            DispatchQueue.main.async {
                self.Image.image = imageData
            }
        }.resume()
    }
}



