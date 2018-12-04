import Foundation
/*
let expectedClassCount = objc_getClassList(nil, 0)
var allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
var autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

for i in 0 ..< actualClassCount {
    if let currentClass: AnyClass = allClasses[Int(i)], String(describing: currentClass).hasSuffix("Test") {
        print(String(describing: currentClass), currentClass)
    }
}
*/


let curPath = FileManager.default.currentDirectoryPath
let fullPath = NSString(string: curPath).appendingPathComponent(#file)
let path = NSString(string: fullPath).deletingLastPathComponent

if let enumerator = FileManager.default.enumerator(atPath: path) {
    while let file = enumerator.nextObject() as? String {

        if file == "main.swift" { continue }

        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["swift", "-F", "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks", NSString(string: path).appendingPathComponent(file)]
        task.launch()
        task.waitUntilExit()
    }
}
else {
    print("Can't get enumerator at path \(path)")
}

