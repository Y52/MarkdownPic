todo:

2.总结往上面提，是重点

3.升级出现的问题不是重点，看的人不关注。

4.最好把升级过程中其它的尝试（几个字段）也写上，让文档无懈可击

5.MGJ-Categories/Build Settings/Search Paths这个，头文件找不到报错为什么就定位问题在这里找要说明，一些开发可能不知道这个

6.如图所示，编译失败，要讲清楚前因后果，不能直接就说到结果。

7.总分方法写，主要的就两大点，升级背景、升级的影响

8.查找问题、问题原因、问题解决讲清楚，要有主次的感觉

9.编译分为precompile、linking、run script三个过程要讲清楚，编译过程主要包括precompile、linking、run script三个过程，还有一些包括组件的compile、account sign过程耗时可以忽略不计。

10.要总结，编译时间加上pod update时间、重复编译时间的总体效果，

11.重复编译要说明，到底是什么意思

## 1.cocoapods升级背景

- 目前部分三方库已经不支持低版本cocoapods，比如Flutter。在Flutter开发环境下执行flutter doctor命令：

```
Doctor summary (to see all details, run flutter doctor -v):
[!] Xcode - develop for iOS and macOS (Xcode 10.2)
    ! CocoaPods out of date (1.6.0 is recommended).
        CocoaPods is used to retrieve the iOS and macOS platform sides plugin
        code that responds to your plugin usage on the Dart side.
        Without CocoaPods, plugins will not work on iOS or macOS.
        For more info, see https://flutter.dev/platform-plugins
      To upgrade:
        sudo gem install cocoapods
```
可以看到Flutter要求至少1.6.0版本的cocoapods，而我们目前使用的是1.2.1版本的cocoapods。

- 经过对比测试，升级高版本的cocoapods对我们主工程的pod update&build有%的耗时降低，提高我们的开发效率。

**1.1 升级出现的问题**

如图所示，在1.8.4版本cocoapods下pod install主工程，然后进行编译编译失败，在Pods/MGJ-Categories/UIDevice+MGJKit.h中报错，找不到文件。

![编译失败](https://github.com/Y52/MarkdownPic/blob/master/pic/filenotfound.png?raw=true)

### 2.1 报错原因查找
1. 找到MGJ-Categories/Build Settings/Search Paths，可以发现所有依赖的搜索路径都存在，这个问题不是由MGJ-Categories引起的。

![Search Paths](https://github.com/Y52/MarkdownPic/blob/master/pic/bug_searchpaths.png?raw=true)

2. 下图报错信息中可以看出这个调用过程是从MGJHangDetector库发起的。

![bug_info](https://github.com/Y52/MarkdownPic/blob/master/pic/buginfo.png?raw=true)

3. 找到MGJHangDetector/Build Settings/Search Paths，发现framework_search_paths是空的，再查看Build Phases/Dependencies，果然没有添加上MGJ-Categories的依赖。
4. 查看[MGJHangDetector.podspec.json](http://gitlab.mogujie.org/ios-team/mgjpodspecs/blob/master/Specs/MGJHangDetector/0.0.4/MGJHangDetector.podspec.json)文件，dependencies字段中添加了MGJ-Categories依赖，没有任何问题。
5. 再找[nodependence](http://gitlab.mogujie.org/ios-team/mgjpodspec-nodependence)源，MGJHangDetector.podspec.json中的dependencies字段被置空了，找到问题源头。

### 2.2 解决方案
- 将mgjpodspec-nodependence源中将MGJHangDetector库移除。

### 2.3 依赖未添加原因
1. Podfile中source的优先级是由上至下的，相同版本的库以第一个找到该库的源为准。
2. Podfile中所有的源如下，可以看到mgjpodspec-nodependence源处在第一位。
```
# 主客加速专用source，组件工程中禁止添加这一行
source 'http://gitlab.mogujie.org/ios-team/mgjpodspec-nodependence.git'
# 三方库framework源，注释该行即可使用源码
source 'http://gitlab.mogujie.org/ios-team/3rdpartyframeworkspec.git'
source 'http://gitlab.mogujie.org/ios-team/mgjpodspec-framework.git'

source 'http://gitlab.mogujie.org/ios-team/mgjpodspecs.git'
source "http://gitlab.mogujie.org/CocoapodsRepos/CocoapodsRepoSpecs.git"
#source 'http://gitlab.mogujie.org/ios-team/cocoapods-official-specs-mirror.git'

# IM 源
source 'http://gitlab.mogujie.org/im/IMPodSpecs.git'
```

### 2.4 低版本不报错原因
- 1.2.1版本中，MGJHangDetector库同样没有添加MGJ-Categories依赖。
- 1.2.1版本中，所有pod都会在Pods/Headers/下生成目录，且它们的Search Paths/Header Search Paths中都添加有"${PODS_ROOT}/Headers/Public"搜索路径，因此即使没有加上MGJ-Categories的依赖，同样能找到所有文件的位置。

## 3 升级对业务的影响
> 为了说明cocoapods升级1.8.4版本对业务的影响，我们进行了1.2.1版本和1.8.4版本对比测试。主要测试了编译和pod update时间，编译中分别记录了precompile、linking、run script三个过程的时间，pod update分别记录了Analyzing、Downloading、Generating、Integrating四个过程的时间。测试电脑型号是MacBook Pro (13-inch, Early 2015，16G内存)。

### 3.1 编译时间对比
||1.8.4|1.2.1|平均耗时对比|
|-|-|-|-|
|总时长|298.8s|300s|平均编译总时长基本相同|
|precompile|10.8s|11.7s|precompile耗时基本相同|
|linking|86.5s|84.2s|linking耗时基本相同|
|run script|143.3s|124.8s|run script耗时增加15%|
**结论**:编译总时长基本接近，1.8.4版本在run script过程耗时较长一些。

### 3.2 重复编译时间对比
||1.8.4|1.2.1|平均耗时对比|
|:-:|:-:|:-:|:-:|
|总时长|87.6s|236.3s|总耗时减少63%|
|precompile|-|-|都不需要precompile|
|linking|79.0s|87.1s|linking耗时减少9%|
|run script|-|137.2s|1.8.4不需要run script|

**结论**:1.2.1版本在修改代码后重复，会重新进行linking和run script过程。1.8.4版本在修改代码后不需要run script过程，所以编译总耗时减少63%。

### 3.3 pod update后编译时间对比
- 两个版本pod update后整个编译过程(precompile、linking、run script等)都会重新进行。

### 3.4 pod update耗时对比
||1.8.4|1.2.1|平均耗时对比|
|-|-|-|-|
|总时长|74s|131s|总耗时降低43.5%|
|Analyzing dependencies|9s|29.5s|Analyzing耗时降低69.5%|
|downloading|11s|19s|-|
|Generating Pods project|39s|60s|Generating耗时降低35%|
|Integrating client project|3s|9s|Integrating耗时降低66.7%|
**结论**:1.8.4版本在pod update耗时上降低了43.5%。除了downloading耗时与更新包数据及网速相关，Analyzing、Generating、Integrating等过程都有不同比例的耗时降低。

