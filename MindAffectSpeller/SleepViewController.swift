/* Copyright (c) 2016-2020 MindAffect.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging

/**
This view controller is used to show the *Sleep screen*.

The Sleep screen lets users – who potentially cannot use touch – temporarily minimize the amount of light and the amount of flickering. It shows only one button, which is used to go back to the Home screen.

By double tapping with one finger, the user or a care-giver can switch to 'Alarm Mode'. In Alarm Mode the Home button is hidden and instead a button is shown which can be used to ring an alarm.
*/
class SleepViewController: UIViewController, SubVC {
	
	/**
	See the `SubVC` protocol.
	*/
	var delegate: SuperVC?

	/**
	A button to go back to the Home screen.
	*/
	@IBOutlet weak var homeButton: NoiseTagButtonView!
	
	/**
	At the bottom of the screen there is an explanation how to turn on and off the Alarm mode.
	*/
	@IBOutlet weak var labelExplanation: UILabel!
	
	
	// We use the alarm button's width and height constraints to let users change the button's size by draggin one finger:
	@IBOutlet weak var alarmButton: NoiseTagButtonView!
	@IBOutlet weak var alarmWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var alarmHeightConstraint: NSLayoutConstraint!
	
	
	/**
	By default we show a button to go back to the Home screen. Alternatively, if `alarmModeIsOn` is `true`, we show an Alarm button instead.
	*/
	var alarmModeIsOn = false {
		didSet {
			// Ignore if nothing changed:
			if alarmModeIsOn == oldValue {
				return
			}
			
			// Update which button is visible:
			homeButton.isHidden = alarmModeIsOn
			alarmButton.isHidden = !alarmModeIsOn
			
			// Update assigned noisetagging actions:
			NoiseTagging.update(view: self.view, forNoiseTaggingWithDelegate: self)
			
			// Update the explanation:
			updateExplanation()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Prepare homeButton:
		self.homeButton.image = UIImage(named: "Icons_Home")
		self.homeButton.frame = Layout.Navigator.NavigationBar.LeftButton.frame
		self.homeButton.noiseTagging.identifier = "Home"
		
		// Prepare alarmButton:
		self.alarmButton.image = UIImage(named: "Icons_Alarm")
		self.alarmButton.isHidden = true
		
		// We use a black background, even if the NoiseTagging settings define a different default background color, because in Sleep mode we want to minimize the amount of emitted light:
		self.view.backgroundColor = UIColor.black
		
		// Add a gesture recogniser to let the user enable alarm mode by double tapping:
		let recogniser = UITapGestureRecognizer(target: self, action: #selector(SleepViewController.doubleTapRecognised(by:)))
		recogniser.numberOfTapsRequired = 2
		self.view.addGestureRecognizer(recogniser)
		
		// Register drags (panning) everywhere:
		let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SleepViewController.panRecognized(by:)))
		self.alarmButton.addGestureRecognizer(panRecognizer)
		
		// Show an explanation:
		self.updateExplanation()
    }
	
	private func updateExplanation() {
		self.labelExplanation.text = self.alarmModeIsOn ? L10n.SleepScreen.Explanation.ifAlarmOn : L10n.SleepScreen.Explanation.ifAlarmOff
	}
	
	/**
	We prefer the home indicator to be hidden.
	*/
	override var prefersHomeIndicatorAutoHidden: Bool {
		return true
	}
	
	
	// MARK: - Actions
	
	@objc func doubleTapRecognised(by recogniser: UITapGestureRecognizer) {
		// Toggle Alarm mode:
		self.alarmModeIsOn = !self.alarmModeIsOn
		
		// If Alarm mode is switched off, we always go back to the Home screen:
		if !self.alarmModeIsOn {
			self.delegate?.goHome()
		}
	}
	
	// We use `trackingFromPointWRTCenter` and `sizeStartOfTracking` in `panRecognized:by` to let the user change the Alarm button's size by dragging from it with one finger:
	var trackingFromPointWRTCenter: CGPoint?
	var sizeStartOfTracking = CGSize(width: 0, height: 0)
	
	@objc func panRecognized(by recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case UIGestureRecognizerState.began:
			// Check whether panning started on the Alarm button:
			let pointWRTButton = recognizer.location(in: self.alarmButton)
			
			// If so, remember where the drag started and how large the Alarm button is at the start of resizing it:
			if self.alarmButton.bounds.contains(pointWRTButton) && !NoiseTagging.trialsAreRunning {
				self.trackingFromPointWRTCenter = CGPoint(
					x: pointWRTButton.x - 0.5 * self.alarmButton.bounds.width,
					y: pointWRTButton.y - 0.5 * self.alarmButton.bounds.height)
				self.sizeStartOfTracking = self.alarmButton.bounds.size
			}
			
		case UIGestureRecognizerState.changed:
			// Ignore if we were not tracking, in which case self.trackingFromPointWRTCenter is nil:
			guard let trackingFromPointWRTCenter = self.trackingFromPointWRTCenter else {
				return
			}
			
			let pointWRTButton = recognizer.location(in: self.alarmButton)
			
			let currentPointWRTCenter = CGPoint(
				x: pointWRTButton.x - 0.5 * self.alarmButton.bounds.width,
				y: pointWRTButton.y - 0.5 * self.alarmButton.bounds.height)
			if currentPointWRTCenter.x * trackingFromPointWRTCenter.x < 0 || currentPointWRTCenter.y * trackingFromPointWRTCenter.y < 0 {
				return
			}
			
			let scaleX = currentPointWRTCenter.x / trackingFromPointWRTCenter.x
			let scaleY = currentPointWRTCenter.y / trackingFromPointWRTCenter.y
			
			// Change the constrants, so the Alarm but rescales:
			self.alarmWidthConstraint.constant = min(max(self.sizeStartOfTracking.width * scaleX, 100), self.view.bounds.width - 2 * 20)
			self.alarmHeightConstraint.constant = min(max(self.sizeStartOfTracking.height * scaleY, 100), self.view.bounds.height - 2 * 20)
			
		case UIGestureRecognizerState.ended:
			// Stop tracking by clearing self.trackingFromPointWRTCenter:
			self.trackingFromPointWRTCenter = nil
			
		default:
			print("WARNING: Unknown UIGestureRecognizerState for pan gesture.")
		}

	}
	
	
	// MARK: - SubVC

	func pagesSettings() -> [Page] {
		return []
	}
	
	
    // MARK: - NoiseTagDelegate

	func startNoiseTagControlOn(noiseTaggingView: UIView) {
		// I assume it is always about our own view's layer:
		assert(noiseTaggingView == view)
		
		if !self.alarmModeIsOn {
			self.homeButton.noiseTagging.addAction(timing: 1) {
				self.delegate?.goHome()
			}
		} else {
			self.alarmButton.noiseTagging.addAction(timing: 0) {
				// Simply play an alarm sound:
				Sound.play(filename: "AlarmSound10s", fileExtension: "wav")
			}
		}
	}
	
	func customBackgroundColorFor(view: UIView) -> UIColor? {
		return UIColor.black
	}
}
