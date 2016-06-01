//
//  ViewController.swift
//  FileIOTestApp
//
//  Created by Grayson Hansard on 6/1/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Cocoa
import FileIO
import Using

class ViewController: NSViewController {

	@IBOutlet var textView: NSTextView?
	@IBOutlet weak var slider: NSSlider?
	private var lastValue: UInt8 = 0

	private var messages = [String]() {
		didSet {
			guard let textView = textView, textStorage = textView.textStorage else { return }
			let range = NSRange(location: 0, length: textStorage.length)
			textStorage.replaceCharactersInRange(range, withString: messages.joinWithSeparator("\n"))
			textView.scrollToEndOfDocument(nil)
		}
	}

	private func formatBytes(bytes: [UInt8]) -> String {
		return "[" + (bytes.map { "\($0)" }).joinWithSeparator(", ") + "]"
	}

	private func doStuff() {
		let path = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("fileiotest.txt")

		messages.append("Writing to file at: \(path)")

		let nextByte: () -> UInt8 = {
			if self.lastValue == UInt8.max { self.lastValue = 0 }
			else { self.lastValue += 1 }
			return self.lastValue
		}

		let numberOfBytes = slider == nil ? 16 : slider!.integerValue

		let file = File(path: path)
		using(file.openForWriting()) { writer in
			let bytes: [UInt8] = (0..<numberOfBytes).map { _ in nextByte() }
			writer.write(bytes)
			self.messages.append("Wrote out \(numberOfBytes) bytes: \(self.formatBytes(bytes))")
		}

		using(file.openForReading()) { reader in
			let bytes: [UInt8] = reader.read(numberOfBytes)
			self.messages.append("Read in \(numberOfBytes) bytes: \(self.formatBytes(bytes))")
		}

		let devRandom = File(path: "/dev/random")
		using(devRandom.openForReading()) { reader in
			let bytes: [UInt8] = reader.read(16)
			self.messages.append("Read in \(bytes.count) random bytes from /dev/random:\n\t \(self.formatBytes(bytes))")
		}

		self.messages.append("\n\n")
	}

	override func viewDidLoad() {
		doStuff()
	}

	@IBAction func reload(_ : AnyObject) {
		doStuff()
	}
}

