import PackageDescription

let package = Package(
  name: "QK",
  exclude: ["src/CoreDataExt", "src/IOS", "src/Image", "src/OpenGL"],
  targets: [
    Target(
      name: "Bridge",
      dependencies: ["Core"]),
    Target(
      name: "Core",
      dependencies: []),
    Target(
      name: "CoreDataExt",
      dependencies: ["Core"]),
    Target(
      name: "Geometry",
      dependencies: ["Core"]),
    Target(
      name: "OSX",
      dependencies: ["Core"]),
    Target(
      name: "SpriteKitExt",
      dependencies: ["Bridge", "Core"]),
    Target(
      name: "SceneKitExt",
      dependencies: ["Bridge", "Core"]),
  ]
)
