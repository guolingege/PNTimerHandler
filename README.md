# PNTimerHandler
A Timer(Swift) tool that let you manage Timer's life cycle automatically

中文介绍：

&emsp;&emsp;用过这两个的可能都知道它们会导致循环引用，即声明并持有它的对象，例如一个UIViewController实例，同时成为了NSTimer/Timer的target。二者形成了循环引用。想要打破循环引用，就需要介入一个第三者持有该定时器，当定时器触发时通过代理通知其他对象，然后在该对象释放时通知该第三者释放定时器，即-dealloc(Objective-C)或deinit(Swift)方法。为了使该持有者能同时支持多个监听者，我采用了注册制，通过给定的字符串identifier来存取定时器。当identifier为空时，取监听者的类名作为identifier。
