//
//  EpisodeViewController.swift
//  musicplayer3_tabs
//
//  Created by JP on 1/17/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit
import AVFoundation

// var timer: Timer?

class EpisodeViewController: UIViewController {
    
    var variableInSecondVc = ""
    
    var audiotest = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let audioUrl = URL(string: "https://rss.art19.com/episodes/4a49a897-61a7-4a2c-81d5-4a7568339d38.mp3") {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                
                func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
                    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
                }
                
                let example = (Float(audioPlayer.duration))
                let myIntValue = Int(example)
                let updated = secondsToHoursMinutesSeconds(seconds: myIntValue)
                let updated3 = "\(updated.0):\(updated.1):\(updated.2)"
                let updated2 = String(describing: updated3)
                // self.episodeDuration.text = updated2
                
                
            } catch let error {
                print(error.localizedDescription)
            }
        } // end player
        


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
                        
                        self.audiotest = (foo["audio"] as? String)!
                        
  
                        
                    } else {
                        // item could not be found
                    }
                    
                    //
                    
                    print(self.audiotest)
                    
                    
                }).resume()

        let fixed = variableInSecondVc.components(separatedBy: " | ")
        let fixedSite = fixed[1]
        let fixedDate = fixed[0]
        episodeTitle.text = fixedSite
        episodeDate.text = fixedDate
        
        print("https://fearthewave.com/\(fixedSite)")
        

        
        // Do any additional setup after loading the view.
        

    } // end view did
    
        @IBOutlet var episodeTitle: UILabel!

    @IBOutlet var episodeDate: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playPod(_ sender: Any) {
        
        // updates slider with progress
       //  Slider.value = 0.0
       //  Slider.maximumValue = Float((audioPlayer?.duration)!)
       //  timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        
        
        audioPlayer.play()
        
    }
    
    @IBAction func pausePod(_ sender: Any) {
        if  audioPlayer.isPlaying{
            audioPlayer.pause()
            timer?.invalidate()
        }else{
            audioPlayer.play()
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

} //end
