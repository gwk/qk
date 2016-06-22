// © 2014 George King. Permission to use this file is granted in license-qk.txt.

import SceneKit


// note: see V3-generated.swift, V4-generated.swift for generated extensions.
public typealias V3 = SCNVector3
public typealias V4 = SCNVector4


func getCtx(_ renderer: SCNSceneRenderer) -> CRGLContext {
  return unsafeBitCast(renderer.context, to: CRGLContext.self)
}

func enableCtx(_ renderer: SCNSceneRenderer) {
  glContextEnable(getCtx(renderer))
}

extension V3: Equatable {}
public func ==(l: V3, r: V3) -> Bool { return l.x == r.x && l.y == r.y && l.z == r.z }


extension V4: Equatable {}
public func ==(l: V4, r: V4) -> Bool { return l.x == r.x && l.y == r.y && l.z == r.z && l.w == r.w }


