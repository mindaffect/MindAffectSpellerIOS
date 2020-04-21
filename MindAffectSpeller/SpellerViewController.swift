/* Copyright (c) 2016-2020 MindAffect.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


private let kIdentifierHomeButton = "Home"


/**
This view controller uses `NoiseTagKeyboardViewController` to show a brain-controllable keyboard. It enables two standard buttons on the keyboard – for typing special symbols such as "." and "," and for speaking out loud the typed text – and it adds one custom button to go back to the Home screen.
*/
class SpellerViewController: UIViewController, SubVC, NoiseTaggingKeyboardDelegate {
	
	// MARK: SubVC protocol
	
	var delegate: SuperVC?
	func pagesSettings() -> [Page] {
		return []
	}
	
	
	// MARK: Keyboard
	
	/**
	`NoiseTagKeyboardViewController` controls the actual keyboard.
	*/
	let keyboardVC = NoiseTagKeyboardViewController()
	
	/**
	We add a custom button to `keyboardVC` to go back to the Home screen.
	*/
	let homeButton = NoiseTagButtonView()
	
	
	// MARK: Preparation
	
    override func viewDidLoad() {
        super.viewDidLoad()
				
		// Add a custom button for going back to the Home screen:
		self.homeButton.frame = CGRect(x: 0, y: 0, width: 1, height: 1) // frame will be set by the keyboardView, which controls the layout
		self.homeButton.image = UIImage(named: "Icons_Home")
		self.homeButton.noiseTagging.identifier = kIdentifierHomeButton
		var customizableButtonStates = self.keyboardVC.customizableButtonStates
		customizableButtonStates.append(CustomizableButtonState.custom(view: homeButton, idInKeyboard: kIdentifierHomeButton))
		self.keyboardVC.customizableButtonStates = customizableButtonStates
		
		// Become the keyboardVC's delegate, so we are informed when our custom button is pressed:
		self.keyboardVC.delegate = self
		
		// We present the keyboard by directly adding keyboardVC's view. Todo: throughout the project use UIViewController.present instead of adding their views directly to the view hierarchy:
		self.keyboardVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
		self.keyboardVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(self.keyboardVC.view)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Push keyboardVC on the NoiseTagging stack:
		NoiseTagging.push(view: self.keyboardVC.view, forNoiseTaggingWithDelegate: self.keyboardVC)
	}
	
	/**
	We prefer the home indicator to be hidden.
	*/
	override var prefersHomeIndicatorAutoHidden: Bool {
		return true
	}
    

	// MARK: - NoiseTagDelegate

	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		// Note that we do not need to do anything here, because we push self.keyboardVC onto the noise tagging stack.
	}
	
	
	// MARK: - NoiseTaggingKeyboardDelegate
	
	/**
	We implement `customActionOnPressOnKeyWith:idInKeyboard` to go back to the Home screen if the Home button is pressed.
	*/
	func customActionOnPressOnKeyWith(idInKeyboard: String) -> Bool {
		switch idInKeyboard {
		case kIdentifierHomeButton:
			// We perform two changes to the noise tagging stack (the pop of our keyboardVC and the pop of ourselves). Combine these in an `updateControls` block for efficiency and better logging:
			NoiseTagging.updateControls {
				NoiseTagging.pop()
				self.delegate?.goHome()
			}

			// Return `true` to indicate that we handled the press:
			return true
		default:
			// Return `false` to indicate that we did NOT handle the press:
			return false
		}
	}
}
