<center><h3>
  Swift的必要性
  </h3><center/>

#### Swift5

ABI更加稳定

#### app表现

swift5共享Runtime 库，配合新的swift编译工具，包大小会明显减少。下载和使用时，代码构建量也有10%(数据来自阿里技术)的降低。

#### Swift Package Manager

类似于node的包管理环境

#### SwiftUI

提高业务开发的效率

#### 三方库

我们的App依赖的大部分三方库已经不再被维护了，有些三方库会影响到App的性能表现。

在未来时间点，所依赖的第三方重要的开发框架有严重问题时(比如AFNetworking)，影响业务开发。

<center><h3>
  目标、成本、过程、结果和反馈
  </h3><center/>

#### 目标

主客引入Swift桥接文件，新的业务将使用Swift开发

#### 成本

- 业务组件间Swift调用有调试成本
- cocoapods需要加入use_frameworks，会衍生较多bug

#### 过程



#### 结果

Swfit的引入是必然，只是引入的时间问题。