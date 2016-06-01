//
//  File.swift
//  FileIO
//
//  Created by Grayson Hansard on 6/1/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import Darwin

public class File {
	let path: String
	private var stats: UnsafeMutablePointer<stat> = nil

	public init(path: String) {
		self.path = path
	}

	public var exists: Bool {
		return fetchStats() != nil
	}

	public var size: off_t {
		return fetchStats()?.st_size ?? -1
	}

	public var blockSize: blksize_t {
		return fetchStats()?.st_blksize ?? -1
	}

	public var blockCount: blkcnt_t {
		return fetchStats()?.st_blocks ?? -1
	}

	public func openForReading() -> FileReader {
		let file = fopen(path, "r")
		return FileReader(file: file)
	}

	public func openForWriting() -> FileWriter {
		let file = fopen(path, "w")
		return FileWriter(file: file)
	}

	public func openForUpdating() -> FileUpdater {
		let file = fopen(path, "r+")
		return FileUpdater(file: file)
	}

	private func fetchStats() -> stat? {
		if stats != nil { return stats.memory }

		stats = UnsafeMutablePointer<stat>.alloc(1)
		if stat(path, stats) == -1 {
			stats.destroy()
			stats.dealloc(1)
			stats = nil
		}
		return stats == nil ? nil : stats.memory
	}
}
