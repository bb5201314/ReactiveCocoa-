//
//  ViewController.m
//  ReactiveCocoa响应式函数编程
//
//  Created by 赵小波 on 2018/2/27.
//  Copyright © 2018年 赵小波. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  initRACSequence];
    
    [self  initswitchSignal];
    
    [self  mergeSingle];
   
    [self  mergeSg];
    
    self.view.backgroundColor=[UIColor  grayColor];
    
    for (int i=0;  i<2;  i++) {
        
        UITextField *field=[[UITextField  alloc]init];
        field.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:field];
    field.frame=CGRectMake(50,100*(i+1)+i*50,self.view.frame.size.width-100,50);
        
        if (i==0) {
            
            field.text=@"用户名";
        }else{
            
            field.text=@"密码";
        }
        
    }
    
    UIButton *loginButton=[UIButton  new];
    [loginButton  setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    loginButton.backgroundColor=[UIColor whiteColor];
 loginButton.frame=CGRectMake(100,400,self.view.frame.size.width-200,50);
    
    
}
//信号合并
-(void)mergeSg{
    
    RACSubject *letters=[RACSubject subject];
    RACSubject *numbers=[RACSubject  subject];
    RACSubject *chinese=[RACSubject  subject];
    
    [[RACSignal  merge:@[letters,numbers,chinese]] subscribeNext:^(id x) {
       
        NSLog(@"merge:%@",x);
    }];
    
    [letters sendNext:@"AA"];
    [numbers sendNext:@"888"];
    [chinese  sendNext:@"你好"];
}
-(void)mergeSingle{
    
    //合并信号量
    
    //1.先创建两个自定义的信号量
    RACSubject *letters=[RACSubject  subject];
    RACSubject *numbers=[RACSubject  subject];
    
    //把两个信号量通过combineLates函数进行合并  combineLatest说明要合并信号量中最后发送的值
    
    //reduce块中是合并规则：把numbers中的值拼接到letters信号量中的值后边。
    

    //经过上面的步骤就是创建所需的相关信号量，也就是相当于架好运输的管道。接着我们就可以通过sendNext方法来往信号量中发送值了，也就是往管道中进行灌水。
    [[RACSignal combineLatest:@[letters,numbers] reduce:^(NSString *letter,NSString *number){
        
        return  [letter  stringByAppendingString:number];
    }]  subscribeNext:^(id x) {
        
        
        NSLog(@"%@*",x);
    }];
    
    
    [letters  sendNext:@"A"];
    [letters  sendNext:@"B"];
    [numbers  sendNext:@"1"];
    [letters  sendNext:@"C"];
    [numbers  sendNext:@"2"];

    
}
-(void)initswitchSignal{
    
    //创建3个自定义信号量 对象
    RACSubject *google=[RACSubject  subject];
    RACSubject *baidu=[RACSubject  subject];
    RACSubject *signalOfSignal=[RACSubject subject];
    
    //获取开关信号
    RACSignal *switchSignal=[signalOfSignal switchToLatest];
    //对通过开关的信号量进行操作
    [[switchSignal map:^id(id value) {
        
        return  [@"https//www." stringByAppendingFormat:@"%@", value];
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@**",x);
    }];
    //通过开关打开百度
    [signalOfSignal  sendNext:baidu];
    [baidu  sendNext:@"baidu.com"];
    [google sendNext:@"google.com"];
    
    //通过开关打开google
    [signalOfSignal  sendNext:google];
    [baidu  sendNext:@"baidu.com"];
    [google  sendNext:@"goole.com"];
    
   
    
}
-(void)initRACSequence{
    
    /**
     把nsarray通过rac_qequencerac_qequence方法生成Swquence
     **/
    RACSequence *sequence=[@[@"are",@"you",@"ok"] rac_sequence];
    
    /**
     获取该数组的信号量
     **/
    RACSignal  *signal=sequence.signal;
    
    /**
     调用信号量的map方法  进行操作  把每个元素的首字母大写  capitalizedString
     lowercaseString  转为小写
     uppercaseString 转为大写
     **/
    RACSignal  *capitailizedSignal=[signal map:^id(NSString *value) {
        
        return [value capitalizedString];
    }];
    
    /***
     
     遍历输出  每个信号量都是独立的
     **/
    [signal  subscribeNext:^(id x) {
        
        NSLog(@"%@********88",x);
        
    }];
    
    [capitailizedSignal  subscribeNext:^(id x) {
        
        NSLog(@"%@********99",x);
    }];
    
}

-(void)uppercaseString{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
