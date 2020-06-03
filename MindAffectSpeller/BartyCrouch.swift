/* Copyright (c) 2016-2020 MindAffect.
Author: Jop van Heesch

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


//
//  This file is required in order for the `transform` task of the translation helper tool BartyCrouch to work.
//  See here for more details: https://github.com/Flinesoft/BartyCrouch
//
import Foundation

enum BartyCrouch {
	enum SupportedLanguage: String {
		case english = "en"
		case dutch = "nl"
	}
	
	static func translate(key: String, translations: [SupportedLanguage: String], comment: String? = nil) -> String {
		let typeName = String(describing: BartyCrouch.self)
		let methodName = #function
		
		print(
			"Warning: [BartyCrouch]",
			"Untransformed \(typeName).\(methodName) method call found with key '\(key)' and base translations '\(translations)'.",
			"Please ensure that BartyCrouch is installed and configured correctly."
		)
		
		// fall back in case something goes wrong with BartyCrouch transformation
		return "BC: TRANSFORMATION FAILED!"
	}
}
