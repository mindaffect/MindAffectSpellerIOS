//
//  AppDelegate.swift
//  PrepareDataWordCompletion
//
//  Created by Jop van Heesch on 04/01/2019.
//  Copyright © 2019 GameTogether. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	struct Element: CustomStringConvertible {
		var description: String {
			return "\(word) (\(inl))"
		}
		
		var word: String
		var inl: Float
	}
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Get the url of the file:
		let filename = "Celex Dutch wordforms"
		guard let urlData = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "txt") else {
			print("WARNING: No txt file found with filename \(filename).")
			return
		}
		
		// Load the file:
		guard let data = try? Data(contentsOf: urlData) else {
			print("WARNING: Problem loading file with url \(urlData).")
			return
		}
		
		// Read in as text:
		guard let wordsAsString = String(data: data, encoding: .utf8) else {
			print("WARNING: Problem reading in file as text with url \(urlData).")
			return
		}
		
		// Divide in components and filter out empty ones:
		let lines = wordsAsString.components(separatedBy: "\n").filter { $0.count > 1 }
		print("n lines = \(lines.count)")
		
		// Map onto Elements:
		let elements = lines.map({ (line) -> Element in
			let values = line.components(separatedBy: "\\")
			return Element(word: values[0], inl: Float(values[1])!)
		})
		
		// Filter out elements with 0 frequency:
		let nonzeroElements = elements.filter { $0.inl > 0 }
		
		// Some words occur multiple times. Combine them into one. TODO CHECK: Ok that I sum the values of Inl?
		var combinedElements = nonzeroElements
		var i = 1
		while i < combinedElements.count - 1 {
			if combinedElements[i].word == combinedElements[i - 1].word {
				combinedElements[i - 1].inl += combinedElements[i].inl
				combinedElements.remove(at: i)
			} else {
				i += 1
			}
		}
		
		// Sort:
		let sortedElements = combinedElements.sorted { $0.inl > $1.inl }
		
		// Print along with indices so I can choose how many words to use:
//		for i in 0 ..< sortedElements.count {
//			print("\(i): \(sortedElements[i])")
//		}
		
		let maxNWordsToUse = 20000
		
		// Convert to a format that we can use in BCIGeneric:
		var stringWithJustTheWords = sortedElements[0].word
		for i in 1 ..< min(maxNWordsToUse, sortedElements.count) {
			stringWithJustTheWords += "," + sortedElements[i].word
		}
		print("====> stringWithJustTheWords = \n\(stringWithJustTheWords)")
		
		// Speed test (on Mac!):
		let startDate = Date()
		for i in 0 ..< sortedElements.count {
			let word = sortedElements[i].word
			if String(word.prefix(5)) == "doelt" {
//			if word == "doeltreffendheid" {
				let interval = Date().timeIntervalSince(startDate)
				print("interval = \(interval)")
				break
			}
		}
	}
	
	public func random(minimum: Int, maximum: Int) -> Int {
		return minimum + Int(arc4random_uniform(UInt32(maximum - minimum + 1)))
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

