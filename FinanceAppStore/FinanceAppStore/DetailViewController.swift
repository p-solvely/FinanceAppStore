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
            
            self.indicatorView.stopAnimating()
            
            let dialog = UIAlertController(title: "알림",
                                           message: "appID 값이 없습니다.",
                                           preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default){ (action: UIAlertAction) -> Void in
                self.navigationController?.popViewController(animated: true)
            }
            
            dialog.addAction(action)
            
            self.present(dialog, animated: true, completion: nil)
            
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let urlString = "https://itunes.apple.com/lookup?id=\(appId)&country=kr"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        session.dataTask(with: request) {data, response, error in
            
            DispatchQueue.main.async {
                
                self.indicatorView.stopAnimating()
                self.bgView.isHidden = true
            
                if error != nil {
                    let dialog = UIAlertController(title: "알림",
                                                   message: "정보를 가져오는 데 실패하였습니다.",
                                                   preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default){ (action: UIAlertAction) -> Void in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    dialog.addAction(action)
                    
                    self.present(dialog, animated: true, completion: nil)
                    
                    return
                }
            
                do {
                
                    guard let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] else {
                        print("error trying to convert data to JSON")
                        return
                    }
                
                    let appDesc = JSONParser.parserAppDesc(jsonResult)
                
                    if let title = appDesc.title {
                        self.titleLabel.text = title
                    }
                    
                    if let atristName = appDesc.atristName {
                        self.artistNameLabel.text = atristName
                    }
                    
                    if let description = appDesc.description {
                        self.textView.text = description
                    }
                    
                    self.textView.isEditable = false
                    self.imageView.image = UIImage(named: "default_image.png")
                    
                    guard let urlSting = appDesc.url else {
                        return
                    }
                    
                    print("urlSting = \(urlSting)")
                
                    DispatchQueue.global().async {
                    
                        let url = URL(string: urlSting)
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
