//
//  JSONParser.swift
//  KakaoBankTest
//
//  Created by sol on 2017. 6. 6..
//  Copyright © 2017년 sol. All rights reserved.
//

import UIKit

class JSONParser {
    
    typealias JSONObject = [String:AnyObject]
    
    class func parserAppRankingList(_ json:JSONObject) -> NSArray {
        
        let appRankingList = NSMutableArray()
        
        guard let jsonFeed = json["feed"] as? JSONObject else {
            return appRankingList;
        }
        
        guard let entrys = jsonFeed["entry"] as? NSArray else {
            return appRankingList;
        }
        
        for entry in entrys {
            
            guard let jsonEntry = entry as? JSONObject else {
                continue
            }
            
            let appInfo = AppInfo()
            
            // title
            if let jsonTitle = jsonEntry["im:name"] as? JSONObject {
                if let title = jsonTitle["label"] as? String {
                    appInfo.title = title
                }
            }
            
            // icon url 
            guard let images = jsonEntry["im:image"] as? NSArray else {
                continue
            }
            
            guard let jsonImage = images.lastObject as? JSONObject else {
                continue
            }
            
            if let image = jsonImage["label"] as? String {
                appInfo.iconUrl = image
            }
            
            // app id
            if let jsonId = jsonEntry["id"] as? JSONObject {
                if let attributes = jsonId["attributes"] as? JSONObject {
                    if let appId = attributes["im:id"] as? String {
                        appInfo.appId = appId
                    }
                }
            }
            
            appRankingList.add(appInfo)

        }
        
        return appRankingList;
    }
    
    class func parserAppDesc(_ json:JSONObject) -> (url:String?, title:String?, atristName:String?, description:String?) {
        
        let results = json["results"] as? NSArray
        let result = results?.firstObject as? JSONObject
        
        let strUrl = result?["artworkUrl512"] as? String
        let title = result?["trackName"] as? String
        let name = result?["artistName"] as? String
        let desc = result?["description"] as? String
        
        return (strUrl, title, name, desc)
    }

}
