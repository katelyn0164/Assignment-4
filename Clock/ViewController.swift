//
//  ViewController.swift
//  Clock
//
//  Created by user249277 on 1/31/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //current live time label
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    // remaining time label
    @IBOutlet weak var timeRemaining: UILabel!
    
    @IBOutlet weak var buttonText: UIButton!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    //Change background for PM
    func updateBackgroundColorBasedOnTime() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        // Assuming 0-11 is AM and 12-23 is PM
        if hour >= 12 {
            // PM: Darker background
            view.backgroundColor = UIColor.darkGray
        } else {
            // AM: Lighter background
            view.backgroundColor = UIColor.white
        }
    }
    
    //Variables
    var timer = Timer()
    var timeLeft : Int?
    var alarm: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getCurrentTime()
        timeRemaining.text = "Time Remaining: "
        
        guard let musicPath = Bundle.main.path(forResource: "Alarm", ofType: "wav")
        else {print("not found")
                    return}
                let url = URL(fileURLWithPath: musicPath)
                do{
                    alarm = try AVAudioPlayer(contentsOf: url)
                }catch{}
    }
    
    //Get live Time
    private func getCurrentTime() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
    }
    
    //Format Live Time
    @objc func currentTime() {
        let formatter = DateFormatter();
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        currentTimeLabel.text = formatter.string(from: Date())
        
    }
    
    //UIDatePicker
    @IBAction func timerPicker(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        timeRemaining.text = formatter.string(from: sender.date)
            print("Timer fired!")
    
        }
    
    //Start - Stop Button
    @IBAction func startStopButton(_ sender: UIButton) {
        if (buttonText.currentTitle == "Stop Music") {
            stopMusic()
            buttonText.setTitle("Start", for: .normal)
        }
        else {
            let date = self.timePicker.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let hour = components.hour!
            let minute = components.minute!
            
            timeLeft = hour * 3600 + minute * 60
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(startCountDown) , userInfo: nil, repeats: true)
            buttonText.setTitle("Stop Music", for: .normal)
        }
    }
    
    //Music/Alarm sound not needed anymore
    
    @objc func startCountDown() {
           if (timeLeft! >= 0) {
               timeRemaining.text = "Time Remaining: \(timeLeft!)"
               timeLeft! -= 1
           }
           else {
               playMusic();
           }
       }
       
       func playMusic() {
           alarm?.play()
       }
       
       func stopMusic() {
           alarm?.stop()
       }
        
    }
