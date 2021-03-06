//
//  TableViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 1/15/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit
var audiotest = ""

class TableViewController: UITableViewController {
    
    var TableData:Array< String > = Array < String >()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change to https and change info plist before prod
        get_data_from_url("https://api.myjson.com/bins/u5al5")
        
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = TableData[indexPath.row]
        
        cell.accessoryType = .detailDisclosureButton
        
        //this is where I want to return the audio URL which I then would pass into the next method
        print(TableData[indexPath.row])
        
        // extract json audio file
        
        let url = URL(string: "http://www.fearthewave.com/fearthewave.json")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            let json: Any?
            do{
                json = try JSONSerialization.jsonObject(with: data, options: [])
            }
            catch{
                return
            }
            
            guard let data_list = json as? [[String:Any]] else {
                return
            }
            
            if let foo = data_list.first(where: {$0["episode"] as? String == "Houston Preview"}) {
                // do something with foo
                
                audiotest = (foo["audio"] as? String)!
                print(audiotest)
                
                if let audioUrl = URL(string: audiotest) {
                    
                    // then lets create your document folder url
                    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    // lets create your destination file url
                    let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                    
                    //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
                    
                    do {
                        
                        // audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                        
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                } // end player
                
                
            } else {
                // item could not be found
                
            }
            
            //
            
        }).resume()
        
        // end json audio file extraction
        
        
        if let audioUrl = URL(string: "https://rss.art19.com/episodes/87c66abc-28a5-4137-a58e-ef7f62c8149c.mp3") {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                
                cell.accessoryType = .checkmark
                
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // doSomethingWithItem(indexPath.row)
        
        if let audioUrl = URL(string: "https://rss.art19.com/episodes/87c66abc-28a5-4137-a58e-ef7f62c8149c.mp3") {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.relativePath) {
                print("The file already exists at path")
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = .checkmark
                
                //show file downloaded
                // removed in new vc
                // self.checkDownload.text = "Downloaded"
                // checkDownload.backgroundColor = UIColor.green
                
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                }).resume()
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = .checkmark
                
            }
        }
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0;//Choose your custom row height
    }
    
    
    func get_data_from_url(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            self.extract_json(data!)
        })
        
        task.resume()
        
    }
    
    func extract_json(_ data: Data)
    {
        let json: Any?
        do{
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch{
            return
        }
        
        guard let data_list = json as? NSArray else {
            return
        }
        
        if let shows_list = json as? NSArray
        {
            for i in 0 ..< data_list.count
            {
                if let shows_obj = shows_list[i] as? NSDictionary
                {
                    let episode_name = shows_obj["episode"] as? String
                    let episode_date = shows_obj["date"] as? String
                    TableData.append(episode_date! + " | " + episode_name!)
                    // this is where I want to capture the URL without showing it as text
                    let epside_audio = shows_obj["url"] as? String
                }
                
            }
        }
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})
        
    }
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "passer", sender: indexPath)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destination as! EpisodeViewController
            controller.variableInSecondVc = TableData[indexPath.row]
        }
    }
    
    
    // end
}

