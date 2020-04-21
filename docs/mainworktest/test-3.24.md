#### 整体分布情况 

| 模块                                              |  100w占比   |   20w占比    | 线程  | 备注 |
| ------------------------------------------------- | :---------: | :----------: | :---: | ---- |
| MTLCommandQueue _submitAvaliableCommandBuffers    |      2      |     3.8      |  子   |      |
| FigRemote_CreatePixelBufferFromSerializedAtomData |      2      |     3.4      |  子   |      |
| IODISpatchCalloutFromCFMessage                    | 7.8主+0.8子 | 16.2主+1.8子 | 主&子 |      |
| nw_channel_update_input_source                    |     6.2     |     3.0      |  子   |      |
| Operation                                         | 2.0主+1.8子 | 1.1主+0.7子  | 主&子 |      |

