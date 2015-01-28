// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


let args = map(1..<C_ARGC) { String.fromCString(C_ARGV[Int($0)])! }
main(args)
