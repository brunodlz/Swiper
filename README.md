# Swiper
UIView sublass for creating Tinder like swipe cards, with a peek view.

[![codebeat badge](https://codebeat.co/badges/3c48b977-4c55-44cf-b897-7089d01dd9ce)](https://codebeat.co/projects/github-com-gkye-swiper)
[![Version](https://img.shields.io/cocoapods/v/Swiper.svg?style=flat)](http://cocoapods.org/pods/Swiper)
[![License](https://img.shields.io/cocoapods/l/Swiper.svg?style=flat)](http://cocoapods.org/pods/Swiper)
[![Platform](https://img.shields.io/cocoapods/p/Swiper.svg?style=flat)](http://cocoapods.org/pods/Swiper)

# TODO
- [ ] Fix reloading/bump spec

![Demo](https://raw.githubusercontent.com/gkye/Swiper/master/demoGif.gif)
## Installation

Swiper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Swiper'
```

# Usage
Check out the demo app for a detailed example.

### Adding Swiper View
A `Swiper` view can be added via storyboard or programmatically
```swift
var swiperView = Swiper(frame: CGRect(x: 0, y: 0, width: 350, height: 350)))
view.addSubview(swiperView)
swipeView.delegate = self
swipeView.dataSource = self
```

## Protocols

#### DataSource

Returns the images to be displayed within the `Swiper` view.

```swift
public func cardData() -> [SwiperData]
```
Returns the number of items to be displayed by the `Swiper` view.
```swift
public func numberOfCards()->Int
```

#### Delegate

Method is called when the `Swiper` view is first display and each time a swipe actions occurs. Returns the current index of the card and its `dataSource`
```swift
public func didShowCardAtIndex(index: Int, dataSource: SwiperData)
```
Method is called when the `Swiper` view is swipped left or programtically `undoSwipe`. Returns the current index of the card and its dataSource
```swift
public func didUndoAction(index: Int, dataSource: SwiperData)
```
Method is called when the `Swiper` view is tapped. Returns the current index of the card of the current item
```swift
public func didSelectCardAtIndex(index: Int)
```
Method is called when the `Swiper` view is no more items to be displayed from its current dataSource
```swift
public func cardsDidRunOut(status: Bool)
```

### Controlling SwiperView
`Swiper` supports both right and left swipe actions. `Swiper Right` to move to the next card and `Swipe left` to undo an action.
These actions are also supported programtically. 
```swift
public func swipeToNext()
public func undoSwipe()
```
Reloads the `Swiper` views items from its current `dataSource` and refreshes display.
```swift
public func reloadData()
```

# Using the <a href="https://github.com/itsmeichigo/PeekView"> PeekView</a>
Must the `peekViewEnabed = true` and conform to the `peekViewDelegate` in order to use the `PeekView`

```swift
    swipeView.peekViewEnabled = true
    swipeView.peekViewDelegate = self
```

#### PeekView Attributes
In order for the peekView to function a `parentViewController` and `contentViewController` must be set (`actions` are optional). Below is an example.

```swift
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
```
#### Handling PeekView actions
Returns the selected index of selected action from the `PeekView`
```swift
func swiperPeekViewDidSelectAtionAtIndex(index: Int)
````

# Dependencies
* <a href="https://github.com/itsmeichigo/PeekView"> PeekView </a>
* <a href="https://github.com/AugustRush/Stellar"> Stellar </a>

## License

Swiper is available under the MIT license. See the LICENSE file for more info.


