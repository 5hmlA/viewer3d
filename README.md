
[![build](https://github.com/ZuYun/viewer3d/actions/workflows/flibbuild.yml/badge.svg)](https://github.com/ZuYun/viewer3d/actions/workflows/flibbuild.yml)  [![publish](https://github.com/ZuYun/viewer3d/actions/workflows/publish.yml/badge.svg)](https://github.com/ZuYun/viewer3d/actions/workflows/publish.yml)    [![pages-build-deployment](https://github.com/ZuYun/viewer3d/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/ZuYun/viewer3d/actions/workflows/pages/pages-build-deployment)

## what is it

[![online](https://img.shields.io/badge/online-test-green)](https://zuyun.github.io/viewer3d/#/)

https://user-images.githubusercontent.com/9412501/159005037-d84e412f-8bf2-4045-a907-c6a889db8f2c.mp4

## how to use

```dart
Center(
  child: View3D.me(),
)

Center(
  child: View3D.autoReset(200,200,60),
)

```
#### customization

```dart

const View3D(
    this.width,
    this.height,
    this.thickness, {
    Key? key,
    this.sides,
    this.backgroundColor = Colors.transparent,
    this.resetTarget,
    this.reset = const ResetNormal(),
})

```

