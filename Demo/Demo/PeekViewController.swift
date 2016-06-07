//
//  PeekViewController.swift
//  Demo
//
//  Created by George on 2016-06-06.
//  Copyright © 2016 George Kye. All rights reserved.
//

import Foundation
import UIKit


class PeekViewController: UIViewController{
  
  
  var image: UIImage!
  var labelText: String!
  
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var label: UILabel!
  
  override func viewDidLoad() {
    imageView.image = image
    label.text = labelText
  }
  
  
  @available(iOS 9.0, *)
  override func previewActionItems() -> [UIPreviewActionItem] {
    let dummyAction = UIPreviewAction(title: "3D Touch is Awesome!", style: .Default, handler: { action, previewViewController in
      print("Action selected!")
    })
    
    return [dummyAction]
  }
}