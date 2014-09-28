# © 2014 George King.
# Permission to use this file is granted in license-qk.txt.

# $@: The file name of the target of the rule.
# $<: The name of the first prerequisite.
# $^: The names of all the prerequisites, with spaces between them. 

math: src-qk/math/math-generated.swift
	swiftc -parse src-qk/qk-types.swift $^

src-qk/math/math-generated.swift: gen-math.py
	./$^ > $@

clean:
	rm src-qk/math/math-generated.swift
