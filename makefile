# © 2014 George King.
# Permission to use this file is granted in license-qk.txt.

# $@: The file name of the target of the rule.
# $<: The name of the first prerequisite.
# $^: The names of all the prerequisites, with spaces between them. 

default: all

src/math/math-generated.swift: gen-math.py
	./$^ > $@

.PHONY: default all math

all: math

math: src/math/math-generated.swift
	xcrun -sdk macosx swiftc -parse src/*.swift src/math/*.swift

clean:
	rm src/math/math-generated.swift
