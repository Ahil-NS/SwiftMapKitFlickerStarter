//
//  PopVC.swift
//  SwiftMapKitFlickerStarter
//
//  Created by MacBook on 1/22/19.
//  Copyright © 2019 Ahil. All rights reserved.
//

import UIKit

class PopVC: UIViewController, UIGestureRecognizerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    var passedImage: UIImage!
    
    func initData(forImage image: UIImage){
        passedImage = image
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = passedImage
        addDoubleTap()
    }
    
    func addDoubleTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewWasDoubleTapped) )
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }


    @objc func viewWasDoubleTapped(){
        self.dismiss(animated: true, completion: nil)
    }
}
