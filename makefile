# © 2014 George King.
# Permission to use this file is granted in license-qk.txt.

# $@: The file name of the target of the rule.
# $<: The name of the first prerequisite.
# $^: The names of all the prerequisites, with spaces between them. 

default: all

src/core/mat-generated.swift: tools/gen-mat.py
	$^ > $@

src/core/vec-generated.swift: tools/gen-vec.py
	$^ > $@

src/cr/CGPoint-generated.swift: tools/gen-vec.py
	$^ CGPoint 2 CoreGraphics > $@

src/cr/CGVector-generated.swift: tools/gen-vec.py
	$^ CGVector 2 CoreGraphics > $@

_bld/gen-cd-entities: src/core/func.swift src/core/Set.swift src/core/types.swift src/core/util.swift src/CoreData/NSManagedObjectModel.swift src/foundation/NSError.swift src/foundation/NSFileManager.swift src/foundation/NSOutputStream.swift src/std/Array.swift src/std/Character.swift src/std/Dictionary.swift src/std/Int.swift src/std/Optional.swift src/std/String.swift tools/gen-cd-entities.swift tools/main.swift
	mkdir -p _bld
	xcrun -sdk macosx swiftc $^ -o $@

.PHONY: default clean gen all cd core cr foundation geom gl img ios scn std parse

clean:
	rm -f src/core/mat-generated.swift
	rm -f src/core/vec-generated.swift
	rm -f src/cr/CGPoint-generated.swift
	rm -rf _bld

# all generated source targets.
gen: \
	src/core/mat-generated.swift \
	src/core/vec-generated.swift \
	src/cr/CGPoint-generated.swift \
	src/cr/CGVector-generated.swift

# all real targets.
all: _bld/gen-cd-entities gen

# parse targets ordered by dependency.

std:
	tools/swift-parse-both.sh \
	src/std

core:
	tools/swift-parse-both.sh \
	src/std \
	src/core

foundation:
	tools/swift-parse-both.sh \
	src/std \
	src/core \
	src/foundation

cd:
	tools/swift-parse-both.sh \
	src/std \
	src/core \
	src/foundation \
	src/cd

cr:
	tools/swift-parse-both.sh \
	src/std \
	src/core \
	src/foundation \
	src/cr

mac:
	echo tools/swift-parse-mac.sh \
	src/std \
	src/core \
	src/foundation \
	src/mac

ios:
	echo tools/swift-parse-ios.sh \
	src/std \
	src/core \
	src/foundation \
	src/ios

img:
	tools/swift-parse-both.sh \
	src/std \
	src/core \
	src/foundation \
	src/img

gl:
	tools/swift-parse-both.sh \
	src/std \
	src/core \
	src/foundation \
	src/cr \
	src/img \
	src/gl

scn:
	tools/swift-parse-both.sh \
	src/std \
	src/core \
	src/foundation \
	src/cr \
	src/img \
	src/gl \
	src/scn

geom:
	tools/swift-parse-both.sh \
	src/std \
	src/core \
	src/foundation \
	src/cr \
	src/img \
	src/gl \
	src/scn \
	src/geom

parse: std core foundation cd cr mac ios img geom gl scn
