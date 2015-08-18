// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import SceneKit


// note: see V3-generated.swift, V4-generated.swift for generated extensions.
typealias V3 = SCNVector3
typealias V4 = SCNVector4


func getCtx(renderer: SCNSceneRenderer) -> CRGLContext {
  return unsafeBitCast(renderer.context, CRGLContext.self)
}

func enableCtx(renderer: SCNSceneRenderer) {
  glContextEnable(getCtx(renderer))
}
