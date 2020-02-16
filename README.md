# app5dm

A new Flutter project.

## Getting Started


This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- listview shrinkwrap 为true高度由自己决定， 否则由parent决定。默认为false
- 打包闪退，因为压缩混淆问题，暂时关闭
- tabview滚动位置联动问题，首先要列表缓存，NestedScrollViewInnerScrollPositionKeyWidget，都设置了key，如果child直接为列表并且设置为缓存，滚动位置会分开，但是当header reset时候，列表位置也会reset，但是可以将列表变为stf，并且keepalive