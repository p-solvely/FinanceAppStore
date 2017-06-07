//
//  RankingListViewController.swift
//  FinanceAppStore
//
//  Created by sol on 2017. 6. 6..
//  Copyright © 2017년 sol. All rights reserved.
//

import UIKit

class RankingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var failView: UIView!
    
    var appRankingList:NSArray? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.isHidden = true
        self.failView.isHidden = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let urlString = "https://itunes.apple.com/kr/rss/topfreeapplications/limit=50/genre=6015/json"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.indicatorView.stopAnimating()
                
                if error != nil {
                    self.failView.isHidden = false
                    return
                }
                
                do {
                    
                    guard let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] else {
                        NSLog("error trying to convert data to JSON")
                        return
                    }
                    
                    self.appRankingList = JSONParser.parserAppRankingList(jsonResult)
                    if( self.appRankingList?.count == 0 ) {
                        
                        let dialog = UIAlertController(title: "알림",
                                                       message: "정보를 가져오는 데 실패하였습니다.",
                                                       preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default)
                        dialog.addAction(action)
                        
                        self.present(dialog, animated: true, completion: nil)
                        
                        return
                    }
                    
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                    
                }
            }
            
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = self.appRankingList?.count else {
            return 0;
        }
        
        return count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "appInfoCell", for: indexPath) as! AppInfoCell
        
        cell.rankingLabel.text = String(indexPath.row+1)
        
        guard let appInfo = self.appRankingList?.object(at: indexPath.row) as? AppInfo else {
            return cell
        }
        
        cell.titleLabel.text = appInfo.title
        cell.icon.image = UIImage(named: "default_image.png")
        
        guard let iconUrl = appInfo.iconUrl else {
            return cell
        }
        
        DispatchQueue.global().async {
            
            let url = URL(string: iconUrl)
            let data = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                cell.icon.image = UIImage(data: data!)
            }
        }
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailSegue" {
            if let destination = segue.destination as? DetailViewController {
                
                guard let selectedIndex = self.tableView.indexPathForSelectedRow?.row else {
                    return
                }
                
                guard let appInfo = appRankingList?.object(at: selectedIndex) as? AppInfo else {
                    return
                }
                
                destination.selectedAppId = appInfo.appId
            }
        }
    }

}
