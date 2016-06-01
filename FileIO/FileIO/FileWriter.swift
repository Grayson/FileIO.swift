//
//  FileWriter.swift
//  FileIO
//
//  Created by Grayson Hansard on 6/1/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Darwin
import Using

public final class FileWriter : Disposable, Writer {
	private let file: UnsafeMutablePointer<FILE>

	internal init(file: UnsafeMutablePointer<FILE>) {
		self.file = file
	}

	deinit {
		dispose()
	}

	public func dispose() {
		if file != nil { fclose(file) }
	}

	public func seek(offset: Int, origin: Int32 = SEEK_SET) {
		assert(file != nil)
		assert(0 == fseek(file, offset, origin))
	}

	public func fill<T>(value: T, times: Int) {
		var mutableValue = value

		for _ in 0..<times {
			assert(1 == fwrite(&mutableValue, sizeof(T), 1, file))
		}
	}

	public func write<T>(object: T) {
		var mutableObject = object
		let numberOfItemsWritten = fwrite(&mutableObject, sizeof(T), 1, file)
		assert(numberOfItemsWritten == 1)
	}

	public func write<T>(array: [T]) {
		let numberOfItemsWritten = array.withUnsafeBufferPointer { fwrite($0.baseAddress, sizeof(T), array.count, file) }
		assert(numberOfItemsWritten == array.count)
	}
}
