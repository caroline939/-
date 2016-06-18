//
//  ViewController.m
//  事件传递，触发
//
//  Created by liuwei on 16/6/13.
//  Copyright © 2016年 liuwei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**   事件的产生和传递  总结
     
    事件的产生和传递过程，就是从父控件一层层到子控件寻找合适的view进行事件拦截，找到最合适的view事件后进行事件的响应
     
     IOS中的事件可以分为3大类型：
     
     1，触摸事件
     2，加速计事件
     3，远程控制事件
     
     
     １．１，响应者对象（UIResponder）
   
     在ios 中不是任何对象都能处理事件， 只有继承了UIResponder的对象才能接受并处理事件，我们称之为“相应增长对象”。
     UIView , UIViewController,UIApplication 
     
     UIResponder 四个对象方法来处理触摸事件
     
     当用户用一根手指触摸屏幕，会创建一个与手指相关的UITouch 对象，一根手指对应一个UITouch 对象。
     
     UITouch的作用
     
     保存着跟手指相关的信息，比如触摸的位置、时间、阶段
     
     当手指移动时，系统会更新同一个UITouch对象，使之能够一直保存该手指在的触摸位置
     
     当手指离开屏幕时，系统会销毁相应的UITouch对象
     
     
     一根或者多根手指开始触摸view，系统会自动调用view的下面方法
     - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
     
     一根或者多根手指在view上移动，系统会自动调用view的下面方法（随着手指的移动，会持续调用该方法）
     - (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
     
     一根或者多根手指离开view，系统会自动调用view的下面方法
     - (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
     
      触摸结束前，某个系统事件(例如电话呼入)会打断触摸过程，系统会自动调用view的下面方法
     - (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
     
     
     
     加速计事件
     
     - (void)motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);
     - (void)motionEnded:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);
     - (void)motionCancelled:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);
     
     远程控制事件
     - (void)remoteControlReceivedWithEvent:(nullable UIEvent *)event
     
     细节要注意:
     1,如果两根手指同时触摸一个view,那么view 只会调用一次touchesBegan:WithEvent方法，touches参数中装着2个UITouch对象.
     2.如果两个手指一前一后分开触摸同一个View 那么view会分别调用2次touchesBegan:withEvent 方法，并且每次调用时的touches参数只包含一个UITouch对象。。
     
     UIviewController 的触摸事件相当于，控制器自带的view 的触摸事件。UIView 的触摸事件相当于，本身的触摸事件。
     
     
     
     (三 )ios 中事件的产生和传递
     发生触摸事件后， 系统会将该事件加入到一个由UIApplication管理事件队列中。。为什么是队列而不是栈。队列特点，先进先出，先产生的事件先处理，才符合常理。
     
     UIApplication 会从事件队列中，取出最前面的事件，并将事件分下去以便处理。先发给应用程序的主窗口
     
     主窗口会在视图层次结构中找到一个最合适的视图来处理触摸事件。
     
     找到合适的视图控件后，就会调用视图控件的touches方法来作具体的事件处理.
     
     3.2  事件的传递
     
     触摸事件的传递是从父控件传递到子控件，也就是从UIApplication--window --寻找处理事件最合适的view
     
     注意，如果父控件不能接收到触摸事件，那么子控件就不可能接收到触摸事件
     
     应用如何找到最合适的控件来处理事件：
     
     1.首先判断自己是否能接受触摸事件
     2.判断触摸点是否在自己身上
     
     3.子控件数组中从后往前遍历子控件，重复前面的两个步骤（所谓从后往前遍历子控件，就是首先查找子控件数组中最后一个元素，然后执行1、2步骤）
     
     4.view，比如叫做fitView，那么会把这个事件交给这个fitView，再遍历这个fitView的子控件，直至没有更合适的view为止。
     
     5.如果没有符合条件的子控件，那么就认为自己最合适处理这个事件，也就是自己是最合适的view。
     
     UIView 不能接收触摸事件三种情况：
     
       1,不允许交互，userInteractionEnabled=NO;
       2.隐藏，如果父控件隐藏 那么子控件也会隐藏，隐藏的控件不能接受事件
       3.如果设置一个控件的透明度<0.01，会直接影响子控件的透明度。alpha：0.0~0.01为透明。
     注意:默认UIImageView不能接受触摸事件，因为不允许交互，即userInteractionEnabled = NO，所以如果希望UIImageView可以交互，需要userInteractionEnabled = YES。
     
     重点，不管视图能不能处理事件，只要点击了视图都会产生事件，关键看该事件是由谁来处理，也就是说， 如果视图不能处理事件，点击视图，还是会产生一个触摸事件，只是该事件不会被点击的视图处理而已。
     
     详述：1.主窗口接收到应用程序传递过来的事件后，首先判断自己能否接手触摸事件。如果能，那么在判断触摸点在不在窗口自己身上
     
     　　　2.如果触摸点也在窗口身上，那么窗口会从后往前遍历自己的子控件（遍历自己的子控件只是为了寻找出来最合适的view）
     
     　　　3.遍历到每一个子控件后，又会重复上面的两个步骤（传递事件给子控件，1.判断子控件能否接受事件，2.点在不在子控件上）
     
     　　　4.如此循环遍历子控件，直到找到最合适的view，如果没有更合适的子控件，那么自己就成为最合适的view。
     
     
     找到最合适的view 后， 就会调用该view的touches 方法处理具体事件，所以，只有找到最合适的view 。把事件传递给最合适的view 后， 才会调用touches 方法进行，事件处理。找不到最合适的view 就不会调用touches方法进行事件处理 。
     
     注意， 之所以， 就会采取 从后往前 遍历子控件的方式， 寻找最合适的view 只是为了做一些循环优化， 因为相比较之下，后添加的view在上面，最有可能是事件的接收者。
     
     最合适的view ，底层剖析。 
     
     两个重要的方法：
     hitTest:withEvent:方法
     pointInside方法
     
     -(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
     {
     // 1.判断下窗口能否接收事件
     if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) return nil;
     // 2.判断下点在不在窗口上
     // 不在窗口上
     if ([self pointInside:point withEvent:event] == NO) return nil;
     // 3.从后往前遍历子控件数组
     int count = (int)self.subviews.count;
     for (int i = count - 1; i >= 0; i--)     {
     // 获取子控件
     UIView *childView = self.subviews[i];
     // 坐标系的转换,把窗口上的点转换为子控件上的点
     // 把自己控件上的点转换成子控件上的点
     CGPoint childP = [self convertPoint:point toView:childView];
     UIView *fitView = [childView hitTest:childP withEvent:event];
     if (fitView) {
     // 如果能找到最合适的view
     return fitView;
     }
     }
     // 4.没有找到更合适的view，也就是没有比自己更合适的view
     return self;
     }
     
     
     
     
     
     文／VV木公子（简书作者）
     原文链接：http://www.jianshu.com/p/2e074db792ba/comments/2400934#
     著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
