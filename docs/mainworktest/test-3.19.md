#### 整体分布情况 

* 数据采集范围是CPU占比0.1%以上的线程，对于低于0.1%的长尾线程不做分析 

  | 模块                                                         | 占比  | 主线程 |  主线程  | 备注                                                         |
  | ------------------------------------------------------------ | ----- | :----: | :------: | ------------------------------------------------------------ |
  | 直播编解码                                                   | 8%    |   否   | iPhone7P |                                                              |
  | 数据打点                                                     | 3.5%  |   否   | iPhone7P |                                                              |
  | TXCAudioCore                                                 | 8.2%  |   否   | iPhone7P |                                                              |
  | TXCRenderView renderframe                                    | 19.1% |   否   | iPhone7P |                                                              |
  | MGJLVChatManager                                             | 2.1%  |   是   | iPhone7P | [NSObject mgj_entityWithDictionary]1.4%，[MGjLIveIMService]0.6% |
  | Comment                                                      | 3%    |   是   | iPhone7P | [MGJLiveCommentTable layoutSubviews]2.5%，[MGJLVTIMErrorAnalysis timErrorConfig]0.3% |
  | MWPCall                                                      | 1.9%  |   是   | iPhone7P | [MGJLVNetworkEngineMWPImpl mgjliveRequest]1.6%，[MGJRequestManager mwpRequest]0.3% |
  | TXLivePlayer                                                 | 1.3%  |   是   | iPhone7P | [MGJEntity entityWithDictionary:parseArray]1.0%，[NSObjec(MGJEntity) mgj_entityToJSONObject]0.3% |
  | MGJNetworkRecorder                                           | 0.3%  |   是   | iPhone7P |                                                              |
  | [MGJLiveBroadcastTimerService scheduledDispatchTimerWithQueue] | 2.3%  |   是   | iPhone7P |                                                              |




#### 其他情况 

- 每隔十秒的直播打点会导致CPU有个激增

- 主线程很多都在解析Entity时占用CPU较多

#### 离屏渲染

- 秒杀货品
- 刚刚剁了手消失动画
- 评论的 View（不包含cell以及其圆角、头像、分享）
- 商品——数字角标
- 点赞，散开的特效
- 左下角菜单——圆角