/* Copyright (c) 2016-2020 MindAffect.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging


// I use an enum for defining the names of settings. This provides better scoping than when defining global constants:
public struct NovaSettingTitles {
	static public let homeScreenUse9Sentences = L10n.StartScreen.Sentences.variant
	static public let homeScreenSentence1 = "\(L10n.sentence) 1"
	static public let homeScreenSentence2 = "\(L10n.sentence) 2"
	static public let homeScreenSentence3 = "\(L10n.sentence) 3"
	static public let homeScreenSentence4 = "\(L10n.sentence) 4"
	static public let homeScreenSentence5 = "\(L10n.sentence) 5"
	static public let homeScreenSentence6 = "\(L10n.sentence) 6"
	static public let homeScreenSentence7 = "\(L10n.sentence) 7"
	static public let homeScreenSentence8 = "\(L10n.sentence) 8"
	static public let homeScreenSentence9 = "\(L10n.sentence) 9"
}


/**
A `SetOfSettings` which defines settings for this app. Note that most settings used in this app are defined in`NoiseTagging.settings`.
*/
class SetOfSettingsNova: SetOfSettings {
	override init() {
		super.init()
		
		// Add our settings. As values we pass sensible default values. These may be changed at runtime:
		add(setting: BoolSetting(title: NovaSettingTitles.homeScreenUse9Sentences, value: false))
		add(setting: TextSetting(title: NovaSettingTitles.homeScreenSentence1, value: L10n.defaultSentence1))
		add(setting: TextSetting(title: NovaSettingTitles.homeScreenSentence2, value: L10n.defaultSentence2))
		add(setting: TextSetting(title: NovaSettingTitles.homeScreenSentence3, value: L10n.defaultSentence3))
		add(setting: TextSetting(title: NovaSettingTitles.homeScreenSentence4, value: ""))
		add(setting: TextSetting(title: NovaSettingTitles.homeScreenSentence5, value: ""))
		add(setting: TextSetting(title: NovaSettingTitles.homeScreenSentence6, value: ""))
		add(setting: TextSetting(title: NovaSettingTitles.homeScreenSentence7, value: ""))
		add(setting: TextSetting(title: NovaSettingTitles.homeScreenSentence8, value: ""))
		add(setting: TextSetting(title: NovaSettingTitles.homeScreenSentence9, value: ""))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - NSCopying
	
	override public func copy(with zone: NSZone? = nil) -> Any {
		let result = SetOfSettingsNova()
		for i in 0 ..< settings.count {
			result.addByReplace(setting: settings[i].copy() as! Setting)
		}
		return result
	}
}
