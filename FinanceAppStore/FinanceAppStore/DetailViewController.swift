//
//  DetailViewController.swift
//  FinanceAppStore
//
//  Created by sol on 2017. 6. 7..
//  Copyright © 2017년 sol. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var textView: UITextView!
    
    var selectedAppId:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appId = selectedAppId else {
            return
        }

        let urlString = "https://itunes.apple.com/lookup?id=\(appId)&country=kr"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        session.dataTask(with: request) {data, response, error in
            
            DispatchQueue.main.async {
                
                self.indicatorView.stopAnimating()
                self.bgView.isHidden = true
            
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
            
                do {
                
                    guard let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] else {
                        print("error trying to convert data to JSON")
                        return
                    }
                
                    typealias AppDesc = (url:String, title:String, atristName:String, description:String)
                    let appDesc = JSONParser.parserAppDesc(jsonResult)
                
                    self.titleLabel.text = appDesc.title
                    self.artistNameLabel.text = appDesc.atristName
                
                    self.textView.text = appDesc.description
                    self.textView.isEditable = false
                
                    DispatchQueue.global().async {
                    
                        let url = URL(string: appDesc.url!)
                        let data = try? Data(contentsOf: url!)
                    
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data!)
                        
                            self.imageView.clipsToBounds = true
                            self.imageView.layer.cornerRadius = 20
                            self.imageView.layer.borderColor = UIColor.lightGray.cgColor
                            self.imageView.layer.borderWidth = 1
                        }
                    }
                
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
