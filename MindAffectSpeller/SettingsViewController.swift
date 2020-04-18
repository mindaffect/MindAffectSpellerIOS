/* Copyright (c) 2016-2020 MindAffect.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging

/**
This view controller provides a number of pages to let the user edit settings.
*/
class SettingsViewController: UIViewController, NoiseTagDelegate {
	
	// Pages:
	var pageSettings: Page!
	var pagesSettings = [Page]()
	
	// Settings we define ourselves (app-specific):
	let settingsSpellerApp = SetOfSettingsNova()
		
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		// To prepare our page hierarchy, first we create five Settings pages (Sound, Keyboard, etc.) and then we combine them in one List page:
				
		// The frame used for all Settings pages:
		let frameSettingsPages = CGRect(x: 0, y: 0, width: 1024 * ScalingUI.scaleWRTRegularIPadScreen, height: 640 * ScalingUI.scaleWRTRegularIPadScreen) // todo: calculate or use constants
		
		// Page 1. Speech and sound:
		let settingTitlesSpeechAndSound = [
			NoiseTagSettingTitles.voice,
			NoiseTagSettingTitles.speechRate,
			NoiseTagSettingTitles.clickSoundOnPress,
			NoiseTagSettingTitles.soundAlarmWhenDisconnecting,
			NoiseTagSettingTitles.enableOtherSounds
		]
		let settingsSpeechAndSound = NoiseTagging.settings.settingsWith(titles: settingTitlesSpeechAndSound)
		let pageSpeechAndSound = Page(title: L10n.Settings.Pages.sound, settings: settingsSpeechAndSound, frame: frameSettingsPages, delegate: self)
		self.pagesSettings.append(pageSpeechAndSound)
		
		// Page 2. Keyboard:
		let settingTitlesKeyboard = [
			NoiseTagKeyboardSettingTitles.keyboardLayout,
			NoiseTagKeyboardSettingTitles.autoCompleteMode,
			NoiseTagKeyboardSettingTitles.languageCodeWordCompletion
		]
		let settingsKeyboard = NoiseTagKeyboardViewController.settings.settingsWith(titles: settingTitlesKeyboard)
		let pageKeyboard = Page(title: L10n.Settings.Pages.keyboard, settings: settingsKeyboard, frame: frameSettingsPages, delegate: self)
		self.pagesSettings.append(pageKeyboard)
		
		// Page 3. Home screen (1):
		let settingTitlesHomeScreen1 = [
			NovaSettingTitles.homeScreenUse9Sentences,
			NovaSettingTitles.homeScreenSentence1,
			NovaSettingTitles.homeScreenSentence2,
			NovaSettingTitles.homeScreenSentence3
		]
		let settingsHomeScreen1 = settingsSpellerApp.settingsWith(titles: settingTitlesHomeScreen1)
		let pageHomeScreen1 = Page(title: L10n.Settings.Pages.Startscreen1.title, settings: settingsHomeScreen1, frame: frameSettingsPages, delegate: self)
		pageHomeScreen1.subTitle = L10n.Settings.Pages.Startscreen.subtitle
		self.pagesSettings.append(pageHomeScreen1)
		
		// Page 4. Home screen (2):
		let settingTitlesHomeScreen2 = [
			NovaSettingTitles.homeScreenSentence4,
			NovaSettingTitles.homeScreenSentence5,
			NovaSettingTitles.homeScreenSentence6,
			NovaSettingTitles.homeScreenSentence7,
			NovaSettingTitles.homeScreenSentence8,
			NovaSettingTitles.homeScreenSentence9
		]
		let settingsHomeScreen2 = settingsSpellerApp.settingsWith(titles: settingTitlesHomeScreen2)
		let pageHomeScreen2 = Page(title: L10n.Settings.Pages.Startscreen2.title, settings: settingsHomeScreen2, frame: frameSettingsPages, delegate: self) // L10n.Settings.Pages.startscreen2
		pageHomeScreen2.subTitle = L10n.Settings.Pages.Startscreen2.subtitle
		self.pagesSettings.append(pageHomeScreen2)
		
		// Page 5. Brain presses:
		let settingTitlesBrainPresses = [
			NoiseTagSettingTitles.timeInBetweenTrials,
			NoiseTagSettingTitles.certaintyRequiredForPress
		]
		let settingsBrainPresses = NoiseTagging.settings.settingsWith(titles: settingTitlesBrainPresses)
		let pageBrainPresses = Page(title: L10n.Settings.Pages.BrainPresses.title, settings: settingsBrainPresses, frame: frameSettingsPages, delegate: self)
		self.pagesSettings.append(pageBrainPresses)
		
		// Combine the five Settings Pages into one List Page:
		self.pageSettings = Page(title: L10n.SettingsScreen.title, subPages: pagesSettings)
	}

	override var prefersStatusBarHidden: Bool {
		get {
			return true
		}
	}
}
