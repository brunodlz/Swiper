//
//  RoundButton.swift
//  Demo
//
//  Created by George on 2016-06-07.
//  Copyright © 2016 George Kye. All rights reserved.
//

import Foundation
import UIKit



@IBDesignable class RoundButton: UIButton {
 
  @IBInspectable var cornerRadius: CGFloat = 15 {
    didSet {
      self.layer.cornerRadius = cornerRadius
    }
  }
  
  @IBInspectable var borderWidth: CGFloat = 15 {
    didSet {
      self.layer.borderWidth = borderWidth
    }
  }
}

