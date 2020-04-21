/* Copyright (c) 2016-2020 MindAffect.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


private let kIdentifierHomeButton = "Home"
private let kFontSizeYesAndNo: CGFloat = 64


class YesNoViewController: UIViewController, SubVC {

	// MARK: - UI
	
	@IBOutlet weak var yesButton: NoiseTagButtonView!
	@IBOutlet weak var noButton: NoiseTagButtonView!
	@IBOutlet weak var closeButton: NoiseTagButtonView!
	
	
	
	// MARK: SubVC protocol
	
	var delegate: SuperVC?
	func pagesSettings() -> [Page] {
		return []
	}
	
	
	// MARK: Preparation
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Prepare Yes and No buttons:
		self.yesButton.title = L10n.YesNo.yes
		self.noButton.title = L10n.YesNo.no
		for button in [self.yesButton, self.noButton] {
			button?.fontOfTitle = UIFont.boldSystemFont(ofSize: kFontSizeYesAndNo)
		}
		
		// Close Button:
		self.closeButton.image = UIImage(named: "Icons_Close")
		self.closeButton.noiseTagging.identifier = "Close Yes/No screen"
		self.closeButton.noiseTagging.participatesInFlickering = false
    }
	
	/**
	We prefer the home indicator to be hidden.
	*/
	override var prefersHomeIndicatorAutoHidden: Bool {
		return true
	}


	// MARK: - NoiseTagDelegate
	
	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		self.yesButton.noiseTagging.addAction(timing: 0) {
			self.ifNotTrainingSpeakTitleOf(button: self.yesButton)
		}
		
		self.noButton.noiseTagging.addAction(timing: 0) {
			self.ifNotTrainingSpeakTitleOf(button: self.noButton)
		}
		
		self.closeButton.noiseTagging.addAction(timing: 0) {
			self.delegate?.goHome()
		}
	}
	
	
	// MARK: - Other
	
	func ifNotTrainingSpeakTitleOf(button: NoiseTagButtonView) {
		if NoiseTagging.mode == .TrainGeneric {
			return
		}
		
		if let actualTitle = button.title {
			Saying.say(text: actualTitle)
		}
	}
}
