//
//  FileReader.swift
//  FileIO
//
//  Created by Grayson Hansard on 6/1/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Darwin
import Using

public final class FileReader : Disposable, Reader {
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

	public func read<T>() -> T {
		let tuple: (pointer: UnsafeMutablePointer<T>, count: Int) = readIntoMemory(1)
		defer { tuple.pointer.dealloc(1) }
		assert(1 == tuple.count)
		return tuple.pointer.move()
	}

	public func read<T>(count: Int) -> [T] {
		let tuple: (pointer: UnsafeMutablePointer<T>, count: Int) = readIntoMemory(count)
		defer { tuple.pointer.dealloc(tuple.count) }
		assert(count == tuple.count)

		var array = [T]()
		var pointer = tuple.pointer
		for _ in 0..<count {
			array.append(pointer.move())
			pointer = pointer.successor()
		}

		return array
	}

	public func seek(offset: Int, origin: Int32 = SEEK_SET) {
		assert(file != nil)
		assert(0 == fseek(file, offset, origin))
	}

	private func readIntoMemory<T>(numberOfItems: Int) -> (UnsafeMutablePointer<T>, Int) {
		let pointer = UnsafeMutablePointer<T>.alloc(numberOfItems)
		return (pointer, fread(pointer, sizeof(T), numberOfItems, file))
	}
}