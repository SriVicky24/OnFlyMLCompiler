//
//  NetworkManager.swift
//  ReactionPredictor
//
//  Created by Sri Vignesh on 24/7/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

class NetworkManager : NSObject {
    
    // Shared instance
    static var shared = NetworkManager()
    
    // Session
    var session : URLSession!
    
    override init() {
        super.init()
        
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    //    MARK: - User Defined Methods
    
    /**
     * Method name: DownloadModelAndMove
     * Description: Downloads a model from api using session. Moves the file from temp location to document directory for compilations
     * Parameters: URL: API , ModelURL: Location to Move
     * Return: Completion Handler - Bool
     */

    func downloadModelAndMove(atURL url : URL, to modelURL : URL, completionHandler: @escaping (_ hasFinished : Bool) -> Void) {
        
        
        self.session.downloadTask(with: url) { (location, response, error) in
            
            guard let location = location else {
                return completionHandler(false)
            }

            do {
                
                if FileManager.default.fileExists(atPath: modelURL.path) {
                   try FileManager.default.removeItem(at: modelURL)
                }

                try  FileManager.default.moveItem(atPath: location.path, toPath: modelURL.path)

                completionHandler(true)

            } catch {
                print("Error in wirting to file")
                completionHandler(false)
            }

        }.resume()
        
    }
    
    
//    func uploadCSV(atURL  url : URL) {
//
//        var request = URLRequest.init(url: URL.init(string: "")!)
//        request.httpMethod = "PUT"
//
//        self.session.uploadTask(with: request, fromFile: url) { (data, response, error) in
//            print(data)
//            print(error)
//            print(response)
//        }.resume()
//
//    }
}
