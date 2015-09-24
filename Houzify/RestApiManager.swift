//
//  RestApiManager.swift
//  Houzify
//
//  Created by Swagat Kumar Bisoyi on 9/23/15.
//  Copyright (c) 2015 Swagat Kumar Bisoyi. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()

//    let baseURL = "https://zoomcar.0x10.info/api/zoomcar?type=json&query=list_cars"
//    let baseURL = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=fuzzy%20monkey"
//    let baseURL = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=barack%20obama&userip=INSERT-USER-IP"
    
    let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?tags=gardenning&;tagmode=any&format=json&nojsoncallback=1"
    
    func getRandomUser(onCompletion: (JSON) -> Void) {
      let route = baseURL
      makeHTTPGetRequest(route, onCompletion: { json, err in
        onCompletion(json as JSON)
      })
    }
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)

        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data)
            println(json)
            onCompletion(json, error)
        })
        task.resume()
    }

    //MARK: Perform a POST Request
    func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        var err: NSError?
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)

        // Set the method to POST
        request.HTTPMethod = "POST"

        // Set the POST body for the request
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: &err)
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data)
            onCompletion(json, err)
        })
        task.resume()
    }

}