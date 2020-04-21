***问题***：头文件引用以boost开头，但是mars才是framework，boost是mars/Headers/下的文件目录，必须要以mars开头才可以。可以在boost前面加上mars/。但是修改的量超级大

1.boost.framework**

- 利用pod lib create boost生成私有库，把boost文件拉到库里面替换Classes文件夹，不要放到Classes下，不然产出的framework中Headers也在Classes下，这样路径就不对了。
- 对比MGJMars/mars.framework中包含的boost头文件，产出boost.framework，mars/boost/下的文件很多都是没用的，拉进来会报C++错误。
- 编译成功后用产出脚本产出framework。
- 产出framework时注意了，因为是对boost这个target进行产出，然后要进入Pods/boost这个target，修改ma ch为static_framework，不然会产出动态库！！！
- 然后动态库和静态库的区别就是动态库是可执行文件，静态库就是文本差不多
- 把boost.framework放到与mars.framework同级目录

**2.MGJMars.framework**

- ```"vendored_frameworks": "mars/mars.framework"```修改为```"vendored_frameworks": "mars/*.framework"```

**3.mars.framework中要修改的头文件**

除了boost以外，还有类似```#include "comm/time_utils.h"```这样的引用方式，为comm产出一个静态库成本较高，且类似的头文件比较少，可以直接为它们添加正确的路径：

- Headers/comm/unix/thread/mutex.h:```#include "mars/comm/assert/__assert.h"```、```#include "comm/time_utils.h"```
- Headers/comm/unix/thread/lock.h:```#include "comm/assert/__assert.h"```、``` #include "comm/thread/mutex.h"```、``` #include "comm/thread/spinlock.h" ```、```#include "comm/time_utils.h"```
- Headers/comm/alarm.h:```#include "comm/xlogger/xlogger.h"```
- Headers/comm/unix/socket/socketselect.h:```#include "comm/socket/socketpoll.h"```
- Headers/comm/unix/socket/socketpoll.h:```#include "comm/socket/unix_socket.h"```、```#include "comm/socket/socketbreaker.h"```
- Headers/comm/unix/socket/socketbreaker.h:```#include "comm/thread/lock.h"```

