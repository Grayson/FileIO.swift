# FileIO

FileIO is a small framework designed that abstracts POSIX file IO into Swift-like idioms and classes.

## Dependencies

FileIO makes use of [Using.swift](http://github.com/Grayson/Using.swift) to provide a pattern for appropriately opening and closing files.  It should be downloaded automatically when you attempt to compile any of the projects in the workspace.  You may need to build a second time if the first time fails.

## Usage

Basic file information can be ascertained by opening creating a `File` object by providing a path.

	let file = File(path: "/path/to/file")
	if file.exists {
		print(file.size)
	}

Operations that read or modify a file currently follow the [NSFileHandle][] pattern of providing different objects for reading, writing, or updating a file.  They should be wrapped in a `using` statement to ensure that they are closed appropriately.

	using (file.openForReading()) { reader in
		let oneByte: UInt8 = reader.read()
	}

You can read and write data structures simply:

	struct Foo { let bar: Int; let baz: Int }
	let writableFoo = Foo(bar: 1, baz: 2)
	using (file.openForWriting()) { writer in
		writer.write(writableFoo)
	}
	
	using (file.openForReading()) { reader in
		let readFoo: Foo = reader.read()
		print(readFoo)
	}

Note that many data structures, such as strings, arrays, and many other types do not store their data inline.  Instead, they have a pointer to the data.  This is often a concern.  Fortunately, `FileIO` abstracts reading and writing arrays.

	let lotsOfBytes = Array<UInt8>(count: 256, repeatedValue: 0x00)
	using (file.openForWriting()) { $0.write(lotsOfBytes) }
	using (file.openForReading()) { let twoHundredAndFiftySixBytes: [UInt8] = $0.read(256) }

## Future

There are three primary issues that I'd like to address as this project matures.

1. Error handling -- Right now, there is no error handling.  I'd like to update this project to throw exceptions that vaguely mirrored data provided by `errno`.
2. Asynchronicity -- All file I/O is handled synchronously.  Many modern I/O idioms provide synchronous and asynchronous file access.  For files, these will likely be tossed into a backgrounded serial queue.
3. Generic stream writing/reading -- In Unix, files are just one form of data streams.  I'd like to extend this to read and write from stdin/stdout/stderr as well as define a generic protocol for handling networked stream interfaces as well.

# Contact

For complaints, compliments, or discussion, I can be reached at:

Grayson Hansard  
[@Grayson](http://twitter.com/Grayson)  
[grayson.hansard@gmail.com](mailto:grayson.hansard@gmail.com)  
[Github/Grayson](http://github.com/Grayson)

[NSFileHandle]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSFileHandle_Class/index.html