//
//  FileUpdater.swift
//  FileIO
//
//  Created by Grayson Hansard on 6/1/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Darwin
import Using

public final class FileUpdater: Disposable, Reader, Writer {
	private let reader: FileReader
	private let writer: FileWriter

	internal init(file: UnsafeMutablePointer<FILE>) {
		reader = FileReader(file: file)
		writer = FileWriter(file: file)
	}

	deinit {
		dispose()
	}

	public func dispose() {
		reader.dispose()
		writer.dispose()
	}

	func seek(offset: Int, origin: Int32 = SEEK_SET) {
		reader.seek(offset, origin: origin)
	}

	func read<T>() -> T {
		return reader.read()
	}

	func read<T>(count: Int) -> [T] {
		return reader.read(count)
	}

	func write<T>(object: T) {
		writer.write(object)
	}

	func write<T>(array: [T]) {
		writer.write(array)
	}
}
