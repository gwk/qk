# © 2014 George King.
# Permission to use this file is granted in license-qk.txt.

# $@: The file name of the target of the rule.
# $<: The name of the first prerequisite.
# $^: The names of all the prerequisites, with spaces between them. 

default: all

src/math/math-generated.swift: tools/gen-math.py
	$^ > $@

_bld/gen-cd-entities: src/core/func.swift src/core/types.swift src/core/util.swift src/CoreData/NSManagedObjectModel.swift src/foundation/NSError.swift src/foundation/NSFileManager.swift src/std/Int.swift src/std/Array.swift src/std/Character.swift src/std/Dictionary.swift src/std/String.swift tools/gen-cd-entities.swift tools/main.swift
	mkdir -p _bld
	xcrun -sdk macosx swiftc 	$^ -o $@

.PHONY: clean default all core

clean:
	rm src/math/math-generated.swift
	rm -rf _bld

all: _bld/gen-cd-entities

core: src/core/*.swift 
	xcrun -sdk macosx swiftc -parse $^

CoreData: src/CoreData/*.swift
	xcrun -sdk macosx swiftc -parse $^

cr: src/cr/*.swift
	xcrun -sdk macosx swiftc -parse $^

foundation: src/foundation/*.swift
	xcrun -sdk macosx swiftc -parse $^
