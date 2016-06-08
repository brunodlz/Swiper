//
//  Swiper.swift
//  Swiper
//
//  Created by George on 2016-06-06.
//  Copyright © 2016 George Kye. All rights reserved.
//

import Foundation
import UIKit
import Stellar
import PeekView

//Protocols

//MARK: Delegate

@objc public protocol SwiperDelegate: class{
  
  func cardsDidRunOut(status: Bool)
  optional func didShowCardAtIndex(index: Int, dataSource: SwiperData)
  func didUndoAction(index: Int, dataSource: SwiperData)
  optional func didSelectCardAtIndex(index: Int)
}

//MARK: DataSource

public protocol SwiperDataSource:class {
  func numberOfCards()->Int
  func cardData()->[SwiperData]
}

//MARK: PeekViewDelegate

@objc public protocol SwiperPeekViewDelegate: class{
  func didUndoAction(index: Int, dataSource: SwiperData)
  func swiperPeekViewAttributes()->SwiperPeekViewAttributes
  optional func swiperPeekViewSize()->CGSize
  optional func swiperPeekViewDidSelectAtionAtIndex(index: Int)
}

//MARK: SwiperPeekView Controller

public class SwiperPeekViewAttributes: NSObject {
  public var parentViewController: UIViewController!
  public var contentViewController: UIViewController!
  public var peekViewActions: [PeekViewAction]? = nil
  public init(parentVC: UIViewController, contentVC: UIViewController, actions: [PeekViewAction]?){
    parentViewController = parentVC
    contentViewController = contentVC
    peekViewActions = actions
  }
}


//MARK: Helpers

private class SwiperSubView: UIView{
  var cornerRadius: CGFloat = 0
  
  private func addImageView(image: UIImage){
    let imageView = UIImageView(frame: self.frame)
    imageView.image = image
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = cornerRadius
    self.addSubview(imageView)
  }
  
  init(image: UIImage, frame: CGRect, cornerRadius: CGFloat){
    super.init(frame: frame)
    self.cornerRadius = cornerRadius
    self.layer.cornerRadius = cornerRadius
    addImageView(image)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

//MARK: SwiperData

public class SwiperData: NSObject{
  public var image: UIImage!
  public var title: String!
  public init(image: UIImage, title: String) {
    self.image = image
    self.title = title
  }
  
}
//public typealias SwiperData = (image: UIImage, title: String)

@IBDesignable public class Swiper: UIView{
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      self.layer.cornerRadius = cornerRadius
    }
  }
  
  //MARK: private variables
  
  private var data = [SwiperData]()
  private var tempData = [SwiperData]()
  private var removedData = [SwiperData]()
  private var count: Int!
  private var currentIndex: Int = 0
  
  
  //MARK: PeekView variables
  public var peekViewEnabled: Bool = false
  public var peekViewHidesStatusBar: Bool = true
  private var peekViewAttributes: SwiperPeekViewAttributes!
  private var peekViewSize: CGSize = (CGSize(width: UIScreen.mainScreen().bounds.width - 30, height: 300))
  private var peekViewFrame: CGRect = CGRect(x: 15, y: (UIScreen.mainScreen().bounds.height - 300)/2, width: UIScreen.mainScreen().bounds.width - 30, height: 300)
  
  //MARK: public variables
  
  public weak var delegate: SwiperDelegate?
  public weak var dataSource: SwiperDataSource?{
    didSet {
      updateData()
    }
  }
  
  public weak var peekViewDelegate: SwiperPeekViewDelegate?{
    didSet{
    }
  }
  
  public override func willMoveToSuperview(newSuperview: UIView?) {
    self.userInteractionEnabled = true
    let leftGuesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGuestureDidSwipe(_:)))
    let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGuestureDidSwipe(_:)))
    addGestureRecognizer(rightGesture)
    addGestureRecognizer(leftGuesture)
    leftGuesture.direction  = .Left
    rightGesture.direction = .Right
    self.layer.cornerRadius = 15
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.showPeekView(_:)))
    longPress.minimumPressDuration = 0.5
    addGestureRecognizer(longPress)
    let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.didTapView(_:)))
    addGestureRecognizer(tapAction)
    
  }
  
  //MARK: Lifecycle
  
  override public func layoutSubviews() {
    animateSubview()
  }
  
  //MARK: UpdateData. Updates variables and subviews
  
  func updateData(){
    count = dataSource?.numberOfCards()
    tempData.removeAll()
    removedData.removeAll()
    if let imgs = dataSource?.cardData(){
      data = imgs
      for i in (0..<count).reverse() {
        tempData.append(data[i])
      }
    }
    layoutSubviews()
    if currentIndex == 0{
      if let last = tempData.last{
        self.delegate?.didShowCardAtIndex?(currentIndex, dataSource: last)
      }
    }
  }
  
  //MARK: Update PeekView attributes
  func updatePeekView(){
    if let vcs = peekViewDelegate?.swiperPeekViewAttributes(){
      peekViewAttributes = vcs
    }
    if let size = peekViewDelegate?.swiperPeekViewSize?(){
      peekViewSize = size
    }
  }
  
  
  //MARK: Reload images

  public func reloadData(){
    updateData()
  }
  
  //MARK: Programatic swipe
  
  public func swipeToNext(){
    didSwipeRight()
  }
  
  public func undoSwipe(){
    undoAction()
  }
  
  //MARK: Tap delegate
  
  internal func didTapView(sender: UITapGestureRecognizer){
    if currentIndex < count{
      delegate?.didSelectCardAtIndex?(currentIndex)
    }
  }
  
  //MARK: Swipe gesture recognizers
  
  internal func swipeGuestureDidSwipe(gesture: UISwipeGestureRecognizer) {
    if gesture.direction == .Left{
      didSwipeRight()
    }else{
      undoAction()
    }
  }
  
  
  //MARK: Swipe Right Action (Remove)
  
  private func didSwipeRight(){
    let subview = self.subviews.last
    if self.subviews.count > 0 {
      subview!.moveX(-500).duration(0.5).completion({
        subview?.removeFromSuperview()
        if let data = self.tempData.last{
          self.removedData.append(data)
          self.tempData.removeLast()
          self.currentIndex += 1
          if let last = self.tempData.last{
            self.delegate?.didShowCardAtIndex?(self.currentIndex, dataSource: last)
          }
          self.animateSubview()
        }
      }).animate()
    }
  }
  
  //MARK: Swipe Left Action (UNDO)
  
  private func undoAction(){
    if let lastRemoved = self.removedData.last{
      self.tempData.insert(lastRemoved, atIndex: tempData.count)
      self.removedData.removeLast()
      self.currentIndex -= 1
      if let last = self.tempData.last{
        self.delegate?.didUndoAction(self.currentIndex, dataSource: last)
      }
      self.animateSubview()
    }
  }
  
  //MARK: PeekView
  
  internal func showPeekView(sender: UILongPressGestureRecognizer){
    if peekViewEnabled && peekViewDelegate != nil{
      updatePeekView()
      peekViewFrame.size = peekViewSize
      PeekView().viewForController(parentViewController: peekViewAttributes.parentViewController, contentViewController: peekViewAttributes.contentViewController, expectedContentViewFrame: peekViewFrame, fromGesture: sender, shouldHideStatusBar: peekViewHidesStatusBar, withOptions: peekViewAttributes.peekViewActions, completionHandler: { optionIndex in
        self.peekViewDelegate?.swiperPeekViewDidSelectAtionAtIndex?(optionIndex)
      })
    }
  }
  
  
  //MARK: AnimateSubviews
  
  //Add subviews to view
  func animateSubview(){
    self.subviews.forEach{
      $0.removeFromSuperview()
    }
    
    for i in 0..<tempData.count {
      if i < count{
        let view = SwiperSubView(image: tempData[i].image, frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), cornerRadius: cornerRadius)
        self.addSubview(view)
      }
    }
    
    for i in 0..<tempData.count {
      if i < 2 && count > 1 && self.subviews.count > 1 {
        let index = i
        let move = CGFloat(-5 + index * 5)
        let opacity = Float(1 - 0.2 * CGFloat(index))
        self.subviews[index].shadowOpacity(opacity).shadowOffset(CGSizeMake(1 - CGFloat(index) * 1, 1 - CGFloat(index) * 1)).shadowRadius(1).moveY(-move).shadowColor(UIColor.grayColor()).duration(1)
        self.subviews[index].shadowOpacity(opacity).shadowOffset(CGSizeMake(1 - CGFloat(index) * 1, 1 - CGFloat(index) * 1)).shadowRadius(1).moveY(-move).duration(1)
          .completion({
          }).animate()
      }
    }
    
    if tempData.count == 0{
      self.delegate?.cardsDidRunOut(true)
    }
    
  }
  
}




