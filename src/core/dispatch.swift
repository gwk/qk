// © 2015 George King.
// Permission to use this file is granted in license-qk.txt.


func outLLA(items: [String]) {
  dispatch_async(dispatch_get_main_queue()) {
    for i in items {
      print(i)
    }
  }
}

func outLLA(items: String...) { outLLA(items) }
