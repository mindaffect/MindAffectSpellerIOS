/* Copyright (c) 2016-2020 MindAffect.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging

/**
This view controller is responsible for the app's initial screen: the *Home Screen*.

From the Home Screen different parts of the app can be accessed. For some of these we make use of the protocols `SuperVC` and `SubVC`. For going to the Settings screen we make use of `NavigatorTreeOfPages` instead, because it provides a suitable animation, and because by presenting our own content using `NavigatorTreeOfPages`, we get the *navigation bar* with the title and two buttons.
*/
class HomeViewController: UIViewController, SuperVC, NoiseTagDelegate, SettingSubscriber {
	
	
	// MARK: - UI Home Page
	
	/**
	We show our UI using `NavigatorTreeOfPages`. We create a `Page` using `viewForHomeScreenPage` and set it as the navigator's initial page.
	*/
	@IBOutlet weak var viewForHomeScreenPage: UIView!
	
	
	// Views with UI components:
	
	@IBOutlet weak var viewBottomBar: UIView!
	@IBOutlet weak var defaultViewSentences: UIView!
	@IBOutlet weak var altViewSentences: UIView!
	
	
	// UI components center:
	
	@IBOutlet weak var sentence1Button: NoiseTagLabeledButtonView!
	@IBOutlet weak var sentence2Button: NoiseTagLabeledButtonView!
	@IBOutlet weak var sentence3Button: NoiseTagLabeledButtonView!
	@IBOutlet weak var yesButton: NoiseTagButtonView!
	@IBOutlet weak var noButton: NoiseTagButtonView!
	
	
	// UI components navigation bar:
	
	let sleepButton = NoiseTagButtonView()
	let brainButton = NoiseTagButtonView()
	
	
	// UI components bottom bar:
	
	@IBOutlet weak var alarmButton: NoiseTagButtonView!
	@IBOutlet weak var settingsButton: NoiseTagButtonView!
	@IBOutlet weak var spellerButton: NoiseTagButtonView!
	@IBOutlet weak var helpButton: NoiseTagButtonView!
	@IBOutlet weak var viewDividingLine1: UIView!
	@IBOutlet weak var viewDividingLine2: UIView!
	
	
	
    // MARK: - Navigation
	
	/**
	We use `navigator` to show our own UI (as a `Page`) and to present the *Settings Screen*.
	*/
	private var navigator: NavigatorTreeOfPages!
			
	/**
	Contrary to most other screens accessible from the Home Screen, we present the Settings Screen using our `navigationHelper`. Therefore this VC is *not* a `SubVC`.
	*/
	let settingsViewController = SettingsViewController()
    
    
    // Sub VCs:
	
	let spellerViewController = SpellerViewController()
	let yesNoViewController = YesNoViewController(nibName: "YesNoViewController", bundle: nil)
	let sleepViewController = SleepViewController(nibName: "SleepViewController", bundle: nil)
	
	
	/**
	We put all sub VCs in `subVCs`, so we can easily do things for all of them.
	*/
    var subVCs = [UIViewController]()
    
    
	/**
	We use this to present and dismiss sub VCs.
	
	In order to present a `SubVC`, we show its view and push it on the NoiseTagging stack. In order to dismiss, we remove the view and pop from the NoiseTagging stack.
	
	If `shownSubVC` is `nil`, we show our own UI.
	*/
    private var shownSubVC: UIViewController? {
        didSet {
            // Ignore if nothing changes:
            if shownSubVC == oldValue {
                return
            }
            
			/**
			We may make *two* changes to the Noisetagging stack (pop as well as push). For efficiency we combine these in an `updateControls` block:
			*/
            NoiseTagging.updateControls {
                // If we were showing another sub VC, remove it and stop noise tagging on it:
                if let actualOldValue = oldValue {
                    actualOldValue.view.removeFromSuperview()
                    actualOldValue.removeFromParent()
					NoiseTagging.pop()
                }
                
                // If we should show another sub vc, show it and enable noise tagging on it:
				if let actualNewValue = self.shownSubVC {
                    self.configure(childViewController: actualNewValue, onView: self.view)
                    if let noiseTagDelegate = actualNewValue as? NoiseTagDelegate {
                        NoiseTagging.push(view: actualNewValue.view, forNoiseTaggingWithDelegate: noiseTagDelegate)
                    }
                }
            }
        }
    }
	
	/**
	See the `SuperVC` protocol.
	*/
    func goHome() {
		self.shownSubVC = nil
    }
	
	
	
	// MARK: - Other
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
				
		// Our UI has been designed specifically for 12.9 inch iPads. If necessary scale to the current screen size:
		ScalingUI.scaleCompletelyFrom12inch9ToCurrentIPad(view: view)
		ScalingUI.scaleCompletelyFrom12inch9ToCurrentIPad(view: viewForHomeScreenPage)
		ScalingUI.scaleCompletelyFrom12inch9ToCurrentIPad(view: altViewSentences)
		
		// Make some views transparent so NoiseTagging's default background color is used:
		self.viewForHomeScreenPage.backgroundColor = nil
		
        // This is also done by NoisTagging, but only once noise tagging is first turned on, so I also do this here:
        UIApplication.shared.isIdleTimerDisabled = true
		
		
		// Prepare Home Screen UI:
				
		// Bars:
		self.viewBottomBar.layer.cornerRadius = 15 * ScalingUI.scaleWRTRegularIPadScreen
		
		// Set button titles/icons:
		self.yesButton.title = L10n.yes
		self.noButton.title = L10n.no
		self.sleepButton.image = UIImage(named: "Icons_Zzz")
		self.brainButton.image = UIImage(named: "Icons_Brain")
		self.alarmButton.image = UIImage(named: "Icons_Alarm")
		self.settingsButton.image = UIImage(named: "Icons_Settings")
		self.helpButton.image = UIImage(named: "Icons_Help")
		self.spellerButton.image = UIImage(named: "Icons_Keyboard")
		for button in [self.sentence1Button, self.sentence2Button, self.sentence3Button] {
			button?.image = UIImage(named: "Icons_Speak")
		}
		
		// The help button should not participate in flickering, because if it is brain-pressed by accident, it is not possible to dismiss the Help without touch:
		self.helpButton.noiseTagging.participatesInFlickering = false
		
		// Set custom identifiers, which are used for logging:
		self.sleepButton.noiseTagging.identifier = "Sleep"
		self.brainButton.noiseTagging.identifier = "Brain control"
		self.spellerButton.noiseTagging.identifier = "Speller"
		self.settingsButton.noiseTagging.identifier = "Settings"
		self.helpButton.noiseTagging.identifier = "Help"
		self.alarmButton.noiseTagging.identifier = "Alarm"
		self.sentence1Button.noiseTagging.identifier = "Sentence 1"
		self.sentence2Button.noiseTagging.identifier = "Sentence 2"
		self.sentence3Button.noiseTagging.identifier = "Sentence 3"
		self.yesButton.noiseTagging.identifier = "Yes"
		self.noButton.noiseTagging.identifier = "No"
		
		// Prepare our page hierarchy and show the first page using a navigationHelper:
		let homeScreenPage = Page(title: L10n.Homescreen.title, view: viewForHomeScreenPage, viewContainsFakeNavigationBar: true, delegate: self)
		self.sleepButton.frame = NavigatorTreeOfPages.frameBackButton
		homeScreenPage.leftViewInTitleBar = sleepButton
		var frameBrainButton = NavigatorTreeOfPages.frameBackButton
		frameBrainButton.origin.x = 0.5 * view.frame.width - 80 - frameBrainButton.width // todo: this is ugly, because I assume that when navigationHelper adds this view, it will do so in a view that is half the width of our own view
		self.brainButton.frame = frameBrainButton
		homeScreenPage.rightViewInTitleBar = brainButton
		self.navigator = NavigatorTreeOfPages(presentingView: self.view, initialPage: homeScreenPage)
		
		// Prepare defaultViewSentences and altViewSentences:
		self.defaultViewSentences.backgroundColor = nil
		self.altViewSentences.backgroundColor = nil
		var frameAltViewSentences = defaultViewSentences.frame
		frameAltViewSentences.origin.x = 0
		frameAltViewSentences.size.width = view.bounds.width
		self.altViewSentences.frame = frameAltViewSentences
		self.defaultViewSentences.superview?.addSubview(altViewSentences)
		for i in 0 ..< 9 { // In the nib's view with alternative sentences we have 9 buttons, which are tagged from 1 to 9
			(self.altViewSentences.viewWithTag(i + 1) as? NoiseTagButtonView)?.noiseTagging.identifier = "alt sentence \(i)"
		}
		
		// Call `updateUI`, which is also called whenever certain settings change:
		self.updateUI()
				
		
		// Prepare our sub VCs:
		
        // Put the sub VCs in an array so we can easily do stuff for each one of them:
		self.subVCs = [spellerViewController, yesNoViewController, sleepViewController]
        
        // Load the their views, so we can show them rapidly:
        for subVC in subVCs {
            let _ = subVC.view
        }
		
		
		// Add a gesture recogniser to let the user open the yes/no screen by pinching:
		let recogniser = UIPinchGestureRecognizer(target: self, action: #selector(HomeViewController.pinchRecognised(by:)))
		view.addGestureRecognizer(recogniser)
		
		
		// We subscribe to some settings, so we can update our UI appropriately whenever they change:
		self.settingsViewController.settingsSpellerApp.subscribe(self, toSettingsWithTitles: [
			NovaSettingTitles.homeScreenUse9Sentences,
			NovaSettingTitles.homeScreenSentence1,
			NovaSettingTitles.homeScreenSentence2,
			NovaSettingTitles.homeScreenSentence3,
			NovaSettingTitles.homeScreenSentence4,
			NovaSettingTitles.homeScreenSentence5,
			NovaSettingTitles.homeScreenSentence6,
			NovaSettingTitles.homeScreenSentence7,
			NovaSettingTitles.homeScreenSentence8,
			NovaSettingTitles.homeScreenSentence9,
			NoiseTagSettingTitles.defaultBackgroundColorTopAndBottomBars,
			NoiseTagSettingTitles.defaultColorItemsOnTopAndBottomBars
		])
    }
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
		if self.isBeingPresented {
			// Prepare sub VCs:
			for subVC in self.subVCs {
				(subVC as? SubVC)?.delegate = self
			}
			
			// Push ourselves for noise tagging:
			NoiseTagging.push(view: view, forNoiseTaggingWithDelegate: self)
		}
	}
	
	private func updateUI() {
		// Get the NoiseTagging settings as wel as this specific app's settings:
		let noiseTaggingSettings = NoiseTagging.settings
		let novaSettings = settingsViewController.settingsSpellerApp
		
		// Set some colors to match the current color scheme defined by NoiseTagging:
		self.viewBottomBar.backgroundColor = noiseTaggingSettings.colorFor(title: NoiseTagSettingTitles.defaultBackgroundColorTopAndBottomBars)
		self.viewDividingLine1.backgroundColor = noiseTaggingSettings.colorFor(title: NoiseTagSettingTitles.defaultColorItemsOnTopAndBottomBars).withAlphaComponent(0.5)
		self.viewDividingLine2.backgroundColor = viewDividingLine1.backgroundColor
		
		// Update whether we show the default sentences view or the alternative one:
		let showAlternativeSentencesView = novaSettings.boolFor(NovaSettingTitles.homeScreenUse9Sentences)
		defaultViewSentences.isHidden = showAlternativeSentencesView
		altViewSentences.isHidden = !showAlternativeSentencesView
		
		// Update UI for the default sentences view:
		sentence1Button.title = novaSettings.textFor(title: NovaSettingTitles.homeScreenSentence1)
		sentence2Button.title = novaSettings.textFor(title: NovaSettingTitles.homeScreenSentence2)
		sentence3Button.title = novaSettings.textFor(title: NovaSettingTitles.homeScreenSentence3)
		
		// Update UI for the alternative sentences view:
		let settingTitles = [
			NovaSettingTitles.homeScreenSentence1,
			NovaSettingTitles.homeScreenSentence2,
			NovaSettingTitles.homeScreenSentence3,
			NovaSettingTitles.homeScreenSentence4,
			NovaSettingTitles.homeScreenSentence5,
			NovaSettingTitles.homeScreenSentence6,
			NovaSettingTitles.homeScreenSentence7,
			NovaSettingTitles.homeScreenSentence8,
			NovaSettingTitles.homeScreenSentence9
		]
		for i in 0 ..< settingTitles.count {
			(altViewSentences.viewWithTag(i + 1) as? NoiseTagButtonView)?.title = novaSettings.textFor(title: settingTitles[i])
		}
	}
    
	/**
	We hide the staus bar.
	*/
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
	
    
    // MARK: - NoiseTagDelegate
	
    
	/**
	See the `NoiseTagDelegate` protocol.
	*/
    func startNoiseTagControlOn(noiseTaggingView: UIView) {
        // Associate actions with views:
		if noiseTaggingView == view {
			// Let our navigationHelper take care of this:
			self.navigator?.startNoiseTagControl()
		} else if noiseTaggingView == viewForHomeScreenPage {
			
			self.sleepButton.noiseTagging.addAction(timing: 1) {
				// Open the Sleep screen:
				self.shownSubVC = self.sleepViewController
			}
			
			self.brainButton.noiseTagging.addAction(timing: 1) {
				NoiseTagging.enterBrainControlLayerFrom(view: self.view)
			}
			
			self.alarmButton.noiseTagging.addAction(timing: 0) {
				// Simply play an alarm sound:
				Sound.play(filename: "AlarmSound10s", fileExtension: "wav")
			}
			
			self.settingsButton.noiseTagging.addAction(timing: 1) {
				self.openSettings()
			}
			
			self.helpButton.noiseTagging.addAction(timing: 0) {
				self.openHelp()
			}
			
			self.spellerButton.noiseTagging.addAction(timing: 1) {
				self.shownSubVC = self.spellerViewController
			}
			
			func addNoiseTaggingActionToSpeakOutLoudTitleOf(button: NoiseTagControl) {
				// Try to get the control's title:
				let title = (button as? NoiseTagButtonView)?.title ?? (button as? NoiseTagLabeledButtonView)?.title
				
				// If the title is nil, ignore:
				guard let actualTitle = title else { return }
				
				// Add the noise tagging action to say out loud the title:
				button.noiseTagging.addAction(timing: 0) {
					Saying.say(text: actualTitle)
				}
			}
			
			let showAlternativeSentencesView = settingsViewController.settingsSpellerApp.boolFor(NovaSettingTitles.homeScreenUse9Sentences)
			
			if !showAlternativeSentencesView {
				for button in [self.sentence1Button, self.sentence2Button, self.sentence3Button] {
					addNoiseTaggingActionToSpeakOutLoudTitleOf(button: button!)
				}
			} else {
				for i in 0 ..< 9 { // ugly hard-coded…
					if let button = (self.altViewSentences.viewWithTag(i + 1) as? NoiseTagButtonView) {
						addNoiseTaggingActionToSpeakOutLoudTitleOf(button: button)
					}
				}
			}
			
			for button in [self.yesButton, self.noButton] {
				addNoiseTaggingActionToSpeakOutLoudTitleOf(button: button!)
			}
            
        } else {
            print("WARNING in HomeViewController: unexpected layer in startNoiseTagControlOn:layer.")
        }
    }
	
	
	
    // MARK: - Actions
	
	func openSettings() {
        // Show settings screen:
        _ = self.settingsViewController.view
		self.settingsViewController.view.frame = self.view.bounds
		self.navigator.push(page: self.settingsViewController.pageSettings)
    }
	
	func openHelp() {
		let infoViewController = InfoViewController()
		self.present(infoViewController, animated: true, completion: nil)
	}
	
	/**
	On a pinch, we open the Yes/No screen:
	*/
	@objc func pinchRecognised(by recogniser: UIPinchGestureRecognizer) {
		if recogniser.state == .began || recogniser.state == .changed {
			if recogniser.scale < 0.5 && self.shownSubVC == nil {
				// Open the Yes/No screen:
				self.shownSubVC = self.yesNoViewController
				
				// Stop tracking this gesture:
				recogniser.isEnabled = false
				recogniser.isEnabled = true
			}
		}
	}
	
	
	
	// MARK: - SettingSubscriber
	
	func valueChangedOf(setting: Setting, inSet setOfSettings: SetOfSettings) {
		self.updateUI()
	}
}







