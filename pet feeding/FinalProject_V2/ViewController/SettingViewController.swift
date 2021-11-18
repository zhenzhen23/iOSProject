//
//  SettingViewController.swift
//  FinalProject_V2
//
//  Created by Qian Wang.
//

import UIKit
import AVFoundation

class SettingViewController: UIViewController, AVAudioPlayerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var volSlider : UISlider!
   
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get all the background music already bought by user
        mainDelegate.readDataFromBGM()

        
    }
    
    //set uislider change the volume of the background music
    @IBAction func volumeDidChange(sender : UISlider)
    {
        mainDelegate.soundPlayer?.volume = volSlider.value
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainDelegate.bgms.count
    }
    
    // how many "wheels" in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //  what should be displayed in each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if mainDelegate.bgms[row].name == nil{
            return "No Bgm Now. Go shop to buy"
        }
        
        else{
            return mainDelegate.bgms[row].name
        }
        
    }
    
    // a background music is chosen when a row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let alertController = UIAlertController(title: "Background Music", message: "Set \(mainDelegate.bgms[row].name)?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {(UIAlertAction) in
            let soundURL = Bundle.main.path(forResource: self.mainDelegate.bgms[row].name, ofType: "mp3")
            let url = URL(fileURLWithPath: soundURL!)
            
            // soundPlayer connects to url of file
            self.mainDelegate.soundPlayer = try! AVAudioPlayer.init(contentsOf: url)
            self.mainDelegate.soundPlayer?.currentTime = 0
            self.mainDelegate.soundPlayer?.volume = self.volSlider.value
            // repeat forever
            self.mainDelegate.soundPlayer?.numberOfLoops = -1
            self.mainDelegate.soundPlayer?.play()
        })
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
     
    }
}
