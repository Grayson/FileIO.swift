//
//  Reader.swift
//  FileIO
//
//  Created by Grayson Hansard on 6/1/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

protocol Reader {
	func read<T>() -> T
	func read<T>(count: Int) -> [T]
}
