/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging

/**
This VC is loaded from the app's Main storyboard. It loads and present a HomeViewController, which currently is the starting point of the Speller app. It also changes some NoiseTagging settings.
*/
class ViewController: UIViewController {
	
	var homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		// Disable accessing the Brain Setup UI by double tapping:
		NoiseTagging.settings.set(boolValue: false, for: NoiseTagSettingTitles.doubleTapOpensBrainSetup)
		
		// Sound the alarm if we accidentaly disconnect from the Decoder:
		NoiseTagging.settings.set(boolValue: true, for: NoiseTagSettingTitles.soundAlarmWhenDisconnecting)
		
		// In this app controls do not change within trials, so we can safely enable Metal for rendering, which should be more precise (see `useMetal` for a more elaborate explanation):
		NoiseTagging.settings.set(boolValue: true, for: NoiseTagSettingTitles.useMetal)

		// Disable access to the Development screen:
		NoiseTagging.settings.set(boolValue: false, for: NoiseTagSettingTitles.twoFingerDoubleTapOpensDeveloperScreen)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Present our main VC:
		homeViewController.modalPresentationStyle = .fullScreen
		present(homeViewController, animated: false, completion: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	

}

