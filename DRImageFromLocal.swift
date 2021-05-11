//
//  DRImageFromLocal.swift
//  Sample App
//
//  Created by Martis on 04/05/21.
//

import UIKit

class DRImageFromLocal: UIViewController {
    
    //MARK:- Outlets
    
    //MARK:- Variables
    var arrImages = [UIImage]()
    
    //MARK:- UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = readLocalJSONFile(forName: "Country")
//        let flagData = UserDefaults.standard.object(forKey: "flags") as? [Data]
//        if flagData != nil {
//            for data in flagData! {
//                self.arrImages.append(UIImage(data: data)!)
//            }
//            print(self.arrImages)//use images where you want
//        }else {
//            parseJson(jsonData: data!) { arrImageData, isFinished in
//                DispatchQueue.main.async {
//                    if isFinished {
//                        print(arrImageData.count)
//                        //save data to user defaults
//                        UserDefaults.standard.set(arrImageData, forKey: "flags")
//                        for data in arrImageData {
//                            self.arrImages.append(UIImage(data: data)!)
//                        }
//                        print(self.arrImages)//use images where you want
//                    }
//                }
//            }
//        }
        let response = parseCodableJson(jsonData: data!)
        let arrCounties = response?.country
        print(arrCounties)
        for i in 0...arrCounties!.count{
            downloadFromServer(url: URL(string: arrCounties![i].flag!)!)
        }
    }
    
    //MARK:- Helpers
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    func parseJson(jsonData: Data, Completion: @escaping (([Data],Bool) -> Void)) {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
            let arrResponse = json["country"] as! [[String:Any]]
            var arrData = [Data]()
            for (_,dict) in arrResponse.enumerated() {
                print(dict)
                let imgStr = dict["flag"] as! String
                arrData.append(try! Data(contentsOf: URL(string: imgStr)!))
                if arrResponse.count == arrData.count {
                        Completion(arrData,true)
                }
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    func parseCodableJson(jsonData: Data) -> Response? {
        do {
            let decodedData = try JSONDecoder().decode(Response.self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    //MARK:- Get Directory Path
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let appURL = documentsDirectory.appendingPathComponent("APP_NAME")
        if !FileManager.default.fileExists(atPath: appURL.path) {
            try! FileManager.default.createDirectory(at: appURL, withIntermediateDirectories: true, attributes: nil)
        }
        return appURL
    }
    
    //MARK:- Download Zip From Server
    func downloadFromServer(url:URL) {
        let zipFileName = url.lastPathComponent
        let downloadPath = self.getDocumentsDirectory()
        
        let newFolder = downloadPath.appendingPathComponent("Flag")
        if !FileManager.default.fileExists(atPath: newFolder.path) {
            do {
                try FileManager.default.createDirectory(atPath: newFolder.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        let fileUrl = newFolder.appendingPathComponent(zipFileName)
  
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            print("FILE AVAILABLE")
            //get images from local folder
        } else {
            print("FILE NOT AVAILABLE")
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            let downloadTask = urlSession.downloadTask(with: url)
            downloadTask.resume()
        }
    }
}

extension DRImageFromLocal : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File Downloaded Location- ",  location)
        
        guard let url = downloadTask.originalRequest?.url else {
            return
        }
        
        let downloadPath = self.getDocumentsDirectory()
        let newFolder = downloadPath.appendingPathComponent("Flag")
        if !FileManager.default.fileExists(atPath: newFolder.path) {
            do {
                try FileManager.default.createDirectory(atPath: newFolder.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        let fileUrl = newFolder.appendingPathComponent(url.lastPathComponent)
        
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            do{
                try FileManager.default.copyItem(at: location, to: fileUrl)
                print("File Downloaded Location- \(fileUrl)" )
            }catch let error {
                print("Copy Error: \(error.localizedDescription)")
            }
        }else {
            print("File Downloaded Location- \(fileUrl)" )
        }
    }
}


