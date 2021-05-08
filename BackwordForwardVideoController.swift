//
//  BackwordForwardVideoController.swift
//  Sample App
//
//  Created by Martis on 04/05/21.
//

import UIKit
import AVKit

class BackwordForwardVideoController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var viewVideoPlayer: UIView!
    
    //MARK:- Variables
    var avPlayer : AVPlayer!
    var avPlayerView = AVPlayerViewController()
    
    //MARK:- UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let seconds = "01:01:23".inSeconds
        print(seconds)
        
        let url = Bundle.main.url(forResource: "NB", withExtension: "mp4")
        
        let videoItem = AVPlayerItem(url: url!)
        avPlayer = AVPlayer(playerItem: videoItem)
        
        avPlayerView.videoGravity = .resizeAspect
        avPlayerView.view.backgroundColor = UIColor.clear
        
        avPlayerView.showsPlaybackControls = true
        
        avPlayer.actionAtItemEnd = .pause
        avPlayerView.player = avPlayer
        viewVideoPlayer.addSubview(avPlayerView.view)
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        avPlayerView.player?.play()
        avPlayerView.player?.isMuted = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        avPlayerView.view.frame = viewVideoPlayer.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Status Bar Update
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    //MARK:- UIButton Action Events
    @IBAction func btnPrevious(_ sender: Any) {
        let currentTime = avPlayerView.player?.currentTime()
        avPlayerView.player?.seek(to: CMTime(seconds: currentTime!.seconds - 5.0, preferredTimescale: 1), completionHandler: { isCompleted in
            if isCompleted {
                self.avPlayerView.player?.play()
            }
        })
    }
    
    @IBAction func btnNext(_ sender: Any) {
        let currentTime = avPlayerView.player?.currentTime()
        avPlayerView.player?.seek(to: CMTime(seconds: currentTime!.seconds + 5.0, preferredTimescale: 1), completionHandler: { isCompleted in
            if isCompleted {
                self.avPlayerView.player?.play()
            }
        })
    }
}

extension String {
    /**
     Converts a string of format HH:mm:ss into seconds
     ### Expected string format ###
     ````
     HH:mm:ss or mm:ss
     ````
     ### Usage ###
     ````
     let string = "1:10:02"
     let seconds = string.inSeconds  // Output: 4202
     ````
     - Returns: Seconds in Int or if conversion is impossible, 0
     */
    var inSeconds : Int {
        var total = 0
        let secondRatio = [1, 60, 3600]    // ss:mm:HH
        for (i, item) in self.components(separatedBy: ":").reversed().enumerated() {
            if i >= secondRatio.count { break }
            total = total + (Int(item) ?? 0) * secondRatio[i]
        }
        return total
    }
}
