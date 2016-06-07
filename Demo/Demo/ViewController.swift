//
//  ViewController.swift
//  Demo
//
//  Created by George on 2016-06-06.
//  Copyright © 2016 George Kye. All rights reserved.
//

import UIKit
import Swiper


class ViewController: UIViewController, SwiperDelegate, SwiperDataSource, SwiperPeekViewDelegate {
  
  @IBOutlet var swipeView: Swiper!
  var number = 2
  var imgs =  [SwiperData]()
  var currentIndex: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imgs = [
      SwiperData(image: UIImage(named: "1")!,  title: "Daenerys Targaryen"),
      SwiperData(image: UIImage(named: "2")!,  title: "Jon Snow"),
      SwiperData(image: UIImage(named: "3")!,  title: "Bran Stark"),
      SwiperData(image: UIImage(named: "4")!,  title: "Tyrion Lannister"),
      SwiperData(image: UIImage(named: "5")!,  title: "Margaery Tyrell"),
      SwiperData(image: UIImage(named: "1")!,  title: "Daenerys Targaryen"),
      SwiperData(image: UIImage(named: "2")!,  title: "Jon Snow"),
      SwiperData(image: UIImage(named: "3")!,  title: "Bran Stark"),
      SwiperData(image: UIImage(named: "4")!,  title: "Tyrion Lannister"),
      SwiperData(image: UIImage(named: "5")!,  title: "Margaery Tyrell"),
      SwiperData(image: UIImage(named: "1")!,  title: "Daenerys Targaryen"),
      SwiperData(image: UIImage(named: "2")!,  title: "Jon Snow"),
      SwiperData(image: UIImage(named: "3")!,  title: "Bran Stark"),
      SwiperData(image: UIImage(named: "4")!,  title: "Tyrion Lannister"),
      SwiperData(image: UIImage(named: "5")!,  title: "Margaery Tyrell")
    ]
    swipeView.delegate = self
    swipeView.dataSource = self
    swipeView.peekViewEnabled = true
    swipeView.peekViewDelegate = self
  }
  
  
  //MARK: IBActions
  
  @IBAction func swipeRight(sender: AnyObject){
    swipeView.swipeToNext()
  }
  
  @IBAction func undoAction(sender: AnyObject){
    swipeView.undoSwipe()
  }
  
  @IBAction func reloadData(sender: AnyObject){
    swipeView.reloadData()
  }
  
  //MARK: DataSource
  
  func cardData() -> [SwiperData] {
    return imgs
  }
  
  func numberOfCards() -> Int {
    return imgs.count
  }
  
  //MARK: Delegate
  
  func cardsDidRunOut(status: Bool) {
    print(status, "card did run out")
  }
  
  func didShowCardAtIndex(index: Int, dataSource: SwiperData) {
    print("card title is", dataSource.title)
    currentIndex = index
  }
  
  func didUndoAction(index: Int, dataSource: SwiperData) {
    print("card title is", dataSource.title)
    currentIndex = index
  }
  
  func didSelectCardAtIndex(index: Int) {
    print("Selected card at \(index)  \(imgs[index].title)")
  }
  
  //MARK: PeekView
  
  func swiperPeekViewSize() -> CGSize {
    return CGSize(width:  UIScreen.mainScreen().bounds.size.width - 30, height: 300)
  }
  
  func swiperPeekViewAttributes() -> SwiperPeekViewAttributes {
    let controller = storyboard?.instantiateViewControllerWithIdentifier("PeekViewController") as! PeekViewController
    controller.image = imgs[currentIndex].image
    controller.labelText = imgs[currentIndex].title
    
    let actions = [
      PeekViewAction(title: "Like", style: .Selected),
      PeekViewAction(title: "Show Details", style: .Default),
      PeekViewAction(title: "Cancel", style: .Destructive) ]
    let attributes = SwiperPeekViewAttributes.init(parentVC: self, contentVC: controller, actions: actions)
    return attributes
  }
  
  func swiperPeekViewDidSelectAtionAtIndex(index: Int) {
    print("Selected \(index)")
  }
  
}

