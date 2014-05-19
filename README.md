libPersistentStructure
======================

A work in progress direct port of Clojure's persistent data structures to Objective-C.

# Getting Started

libPersistentStructure is packaged as a static library for both iOS and OS X, so
there are two ways of incorporating it into an application.

1) Add PersistentStructure as a subproject of your own project.

- Drag PersistentStructure.xcodeproj into your project file tree.
- Click on your project in the file tree; select `Build Phases`
- Expand the `Target Dependencies` phase, then click the `+`.
- Add PersistentStructure(-iOS).
- Expand the `Link Binary With Libraries` phase, then click the `+`.
- Add libPersistentStructure(-iOS).
- Add `$(SRCROOT)/Path/To/PersistentStructure` to the `Header Search Paths` field.

2) Copy-pasta.

- Drag the PersistentStructure sub-directory into your project,
- Make sure `Copy items into destination group's folder` is selected.
- Click OK.

# Copyleft

Released under the MIT License.  See the LICENSE file for more information.
