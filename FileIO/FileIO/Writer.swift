//
//  Writer.swift
//  FileIO
//
//  Created by Grayson Hansard on 6/1/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

protocol Writer {
	func write<T>(object: T)
	func write<T>(array: [T])
}
