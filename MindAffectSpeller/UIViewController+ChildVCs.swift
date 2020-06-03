/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit

/**
For an explanation of this extension, see http://stackoverflow.com/questions/26599858/how-to-properly-add-child-view-controller-in-ios-8-with-swift.

Todo: get rid of this unconventional stuff. Instead use the normal way of presenting view controllers throughout the project. 
*/
extension UIViewController {
	func configure(childViewController: UIViewController, onView: UIView?) {
		var holderView: UIView! = self.view
		if let onView = onView {
			holderView = onView
		}
		addChild(childViewController)
		holderView.addSubview(childViewController.view)
		constrainViewEqual(holderView: holderView, view: childViewController.view)
		childViewController.didMove(toParent: self)
	}
	
	
	func constrainViewEqual(holderView: UIView, view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		//pin 100 points from the top of the super
		let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
		                                toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
		let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
		                                   toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
		let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
		                                 toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
		let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
		                                  toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
		
		holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
	}
}
