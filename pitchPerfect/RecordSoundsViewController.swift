//
//  RecordSoundsViewController.swift
//  pitchPerfect
//
//  Created by René Zelada on 3/24/20.
//  Copyright © 2020 René Zelada. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordbutton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
     var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopButton.isEnabled = false;
    }
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
    }
    @IBAction func pararAudio(_ sender: Any) {
        recordbutton.isEnabled = true;
        stopButton.isEnabled = false;
        recordingLabel.text = "Tap to Record"
        
         audioRecorder.stop()
         let audioSession = AVAudioSession.sharedInstance()
         try! audioSession.setActive(false)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
       
        recordbutton.isEnabled = false;
        stopButton.isEnabled = true;
        recordingLabel.text = "Recording in progress"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
       
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
       
       
    }
    
  
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
       if (flag){
            performSegue(withIdentifier: "audioStopRecording", sender: audioRecorder.url)
        }else{
            print("Recording was not succefull")
        }
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?){
            if segue.identifier == "audioStopRecording"{
                let playSoundsVC = segue.destination as! PlaySoundsViewController
                let recordedAudioURL = sender as! NSURL
                playSoundsVC.recordedAudioURL = recordedAudioURL
            }
        }
    
    }
}

