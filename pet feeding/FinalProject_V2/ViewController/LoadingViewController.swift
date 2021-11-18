//
//  LoadingViewController.swift
//  FinalProject_V2
//
//  Created by Wenzhuo Zhao
//  This controller is used to display the start animation
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet weak var imageView : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load the image
        imageView.loadGif(name: "loading")
        changeToMainPage()
    }
    
    /*
     author: Wenzhuo Zhao
     go to the menu page after 6 seconds
     */
    func changeToMainPage(){
        let time: TimeInterval = 6.3
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self.performSegue(withIdentifier: "GoToMainMenu", sender: self)
        }
    }
}
