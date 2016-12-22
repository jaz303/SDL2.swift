import PackageDescription

let package = Package(
	name: "SDL2",
	targets: [],
	dependencies: [
		.Package(
			url: "https://github.com/jaz303/CSDL2.swift.git",
			majorVersion: 2
		)
	]
)