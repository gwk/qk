# © 2014 George King.
# Permission to use this file is granted in license-qk.txt.

# $@: The file name of the target of the rule.
# $<: The name of the first prerequisite.
# $^: The names of all the prerequisites, with spaces between them. 

default: all

src/core/math-generated.swift: tools/gen-math.py
	$^ > $@

src/cr/V2-generated.swift: tools/gen-math.py
	$^ 2 Flt V2 > $@

src/scn/V3-generated.swift: tools/gen-math.py
	$^ 3 Flt V3 > $@

src/scn/V4-generated.swift: tools/gen-math.py
	$^ 4 Flt V4 > $@

_bld/gen-cd-entities: src/core/func.swift src/core/Set.swift src/core/types.swift src/core/util.swift src/CoreData/NSManagedObjectModel.swift src/foundation/NSError.swift src/foundation/NSFileManager.swift src/foundation/NSOutputStream.swift src/std/Array.swift src/std/Character.swift src/std/Dictionary.swift src/std/Int.swift src/std/Optional.swift src/std/String.swift tools/gen-cd-entities.swift tools/main.swift
	mkdir -p _bld
	xcrun -sdk macosx swiftc $^ -o $@

.PHONY: default clean gen all cd core cr foundation geom gl img ios scn std parse

clean:
	rm -f src/core/math-generated.swift
	rm -f src/cr/V2-generated.swift
	rm -rf _bld

# all generated source targets.
gen: src/core/math-generated.swift src/cr/V2-generated.swift src/scn/V3-generated.swift src/scn/V4-generated.swift

# all real targets.
all: _bld/gen-cd-entities gen

# parse targets ordered by dependency.

std:
	tools/swift-both-parse.sh \
	src/std/*.swift

core:
	tools/swift-both-parse.sh \
	src/std/*.swift \
	src/core/*.swift

foundation:
	tools/swift-both-parse.sh \
	src/std/*.swift \
	src/core/*.swift \
	src/foundation/*.swift

cd:
	tools/swift-both-parse.sh \
	src/std/*.swift \
	src/core/*.swift \
	src/foundation/*.swift \
	src/cd/*.swift

cr:
	tools/swift-both-parse.sh \
	src/std/*.swift \
	src/core/*.swift \
	src/foundation/*.swift \
	src/cr/*.swift

mac:
	echo tools/swift-mac.sh -parse \
	src/std/*.swift \
	src/core/*.swift \
	src/foundation/*.swift \
	src/mac/*.swift

ios:
	echo tools/swift-ios.sh -parse \
	src/std/*.swift \
	src/core/*.swift \
	src/foundation/*.swift \
	src/ios/*.swift

img:
	tools/swift-both-parse.sh \
	src/std/*.swift \
	src/core/*.swift \
	src/foundation/*.swift \
	src/img/*.swift

gl:
	tools/swift-both-parse.sh \
	src/std/*.swift \
	src/core/*.swift \
	src/foundation/*.swift \
	src/cr/*.swift \
	src/img/*.swift \
	src/gl/*.swift

scn:
	tools/swift-both-parse.sh \
	src/std/*.swift \
	src/core/*.swift \
	src/foundation/*.swift \
	src/cr/*.swift \
	src/img/*.swift \
	src/gl/*.swift \
	src/scn/*.swift

geom:
	tools/swift-both-parse.sh \
	src/std/*.swift \
	src/core/*.swift \
	src/foundation/*.swift \
	src/cr/*.swift \
	src/img/*.swift \
	src/gl/*.swift \
	src/scn/*.swift \
	src/geom/*.swift

parse: std core foundation cd cr mac ios img geom gl scn
