//
//  APIClient.swift
//  MuZest
//
//  Created by Никита Туманов on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation

typealias APIClientCompletion = (NSError?, Any?)->()
typealias SessionCompletion = (Data?, URLResponse?, Error?)->()

class APIClient: NSObject {
    
    fileprivate let kItunesAPIErrorDomain = "iTunesAPI"
    fileprivate let kAPIBaseURL = URL(string:"https://itunes.apple.com/")!
    
    static let shared = APIClient()

    fileprivate let session: URLSession
    
    override init() {
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration)
    }
    
    /// # First level JSON request handler constructor
    /// Return a handler to analyze request's response
    func handler(completion: ((NSError?, Any?)->())?, apiErrorDomain: String) -> SessionCompletion {
        return { (data: Data?, response:URLResponse?, error:Error?)->() in
            guard let safeCompletion = completion else {
                return
            }
            
            guard let safeData = data
                else {
                    let noDataError = NSError(domain: apiErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: "no data"])
                    DispatchQueue.main.async {
                        safeCompletion(noDataError, nil)
                    }
                    return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: safeData, options: [])
                
                if let jsonDictionary = jsonResponse as? Dictionary<String, Any>,
                    let jsonError = jsonDictionary["error"] as? Dictionary<String, Any>,
                    let code = jsonError["code"] as? Int    {
                    let error = NSError(domain: apiErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: jsonError["message"] as? String ?? ""])
                    
                    DispatchQueue.main.async {
                        safeCompletion(error, nil)
                    }
                }   else    {
                    DispatchQueue.main.async {
                        safeCompletion(nil, jsonResponse)
                    }
                }
                
            } catch let error {
                let jsonParsingError = NSError(domain: apiErrorDomain, code: 2, userInfo: [NSLocalizedDescriptionKey: error])
                DispatchQueue.main.async {
                    safeCompletion(jsonParsingError, nil)
                }
            }
        }
    }
    
    private func queryWithParams(params: Dictionary<String, Any>) -> String {
        var components: Array<String> = []
        if params.count > 0 {
            for (key, value) in params {
                components += ["\(key)=\((value as AnyObject).description.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!)"]
            }
        }
        
        return components.joined(separator: "&")
    }
    
    private func iTunesRSSURL(path: String, params: Dictionary<String, Any>?) -> URL {
        let mutableParams: Dictionary<String, Any> = params ?? [:]
        
        var relativePath: String = "\(path)\(mutableParams.count > 0 ? "?" : "")"
        relativePath += self.queryWithParams(params: mutableParams)
        
        return URL(string: relativePath, relativeTo: kAPIBaseURL)!
    }
    
    /// Get iTunes URL giving the URL and a callback to call when the request is terminated.
    private func getITURL(URL: URL, completion: @escaping APIClientCompletion) {
        self.session.dataTask(with: URL, completionHandler: self.handler(completion: completion, apiErrorDomain: self.kItunesAPIErrorDomain)).resume()
    }
    
    private func iTunesRSSTopSongPath(limit: Int) -> String? {
        guard let countryCode = Locale.current.regionCode else {
            log.error("Error: Could not get phone's region code")
            return nil
        }
        let dataType = "json"
        let path: String = "\(countryCode)/rss/topsongs/limit=\(limit)/\(dataType)"
        return path
    }

    func top100Songs(completion: @escaping APIClientCompletion) {
        guard let path = iTunesRSSTopSongPath(limit: 100) else {
            completion(nil, nil)
            return
        }
        let url: URL = self.iTunesRSSURL(path: path, params: nil)
        self.getITURL(URL: url, completion: completion)
    }
}

