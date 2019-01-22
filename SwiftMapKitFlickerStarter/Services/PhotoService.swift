//
//  PhotoService.swift
//  SwiftMapKitFlickerStarter
//
//  Created by MacBook on 1/22/19.
//  Copyright © 2019 Ahil. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage


class PhotoService{
    static let instance = PhotoService()
    
    private var imageUrlArray = [String]()
    private var imageArray = [UIImage]()
    
    func retriveUrls(forAnnotation annotation: DroppablePin, handler: @escaping (_ status: Bool) -> ()){
        
        imageUrlArray = []
        
        Alamofire.request(flickrUrl(forApiKey: apiKey, withAnnotation: annotation, andNumberOfPhotos: 10)).responseJSON { (response) in
            
            guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
            let photosDict = json["photos"] as! Dictionary<String, AnyObject>
            let photosDictArray = photosDict["photo"] as! [Dictionary<String, AnyObject>]
            for photo in photosDictArray {
                let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_h_d.jpg"
                self.imageUrlArray.append(postUrl)
            }
            handler(true)
        }
    }
    
    //@escaping - the value can be passes outside the function
    func retriveImages(handler: @escaping (_ status: Bool) -> ()){
        imageArray = []
        
        for url in imageUrlArray{
            Alamofire.request(url).responseImage { (response) in
                guard let img = response.result.value else{return}
                self.imageArray.append(img)
                
                if(self.imageArray.count == self.imageUrlArray.count){
                    handler(true)
                }
            }
        }
        
    }
    
    func cancelAllSession(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach({$0.cancel()})
            uploadData.forEach({$0.cancel()})
            downloadData.forEach({$0.cancel()})
        }
    }
    
    func getImageUrls() -> [String]{
        return imageUrlArray
    }
}
