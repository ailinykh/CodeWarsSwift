import Foundation

let expectedClassCount = objc_getClassList(nil, 0)
var allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
var autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

for i in 0 ..< actualClassCount {
    if let currentClass: AnyClass = allClasses[Int(i)], String(describing: currentClass).hasSuffix("Test") {
        print(String(describing: currentClass), currentClass)
    }
}
