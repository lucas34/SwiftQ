import Foundation
import Danger
import DangerSwiftLint // package: https://github.com/ashfurrow/danger-swiftlint.git

let danger = Danger()

let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

let changelogChanged = allSourceFiles.contains("CHANGELOG.md")
let sourceChanges = allSourceFiles.first(where: { $0.hasPrefix("Sources") })
let isTrivial = danger.github.pullRequest.title.contains("#trivial")

if (danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 10) {
    warn("Big PR, try to keep changes smaller if you can")
}

if !isTrivial && !changelogChanged && sourceChanges != nil {
    warn("""
     Any changes to library code should be reflected in the Changelog.

     Please consider adding a note there and adhere to the [Changelog Guidelines](https://github.com/Moya/contributors/blob/master/Changelog%20Guidelines.md).
    """)
}

if danger.github.pullRequest.title.contains("WIP") {
    warn("PR is classed as Work in Progress")
}

let onlyPodspec = allSourceFiles.contains("SwiftQueue.podspec") && !allSourceFiles.contains("Package.swift")
let onlyPackage = !allSourceFiles.contains("SwiftQueue.podspec") && allSourceFiles.contains("Package.swift")
if onlyPodspec != onlyPackage {
    warn("Only one of either the podspec or SPM package was changed. This might be unintentional – double check.")
}

SwiftLint.lint()
