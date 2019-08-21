//
//  ViewController.m
//  OC
//
//  Created by conan on 2019/8/21.
//  Copyright © 2019年 conan. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>
#import <malloc/malloc.h>

#import "Model.h"
#import "SonModel.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self objectExplore];
}

- (void)objectExplore{
    /**
     64位编译器
     char ：1个字节
     char*(即指针变量): 8个字节
     short int : 2个字节
     int：  4个字节 范围  -2147483648～2147483647
     unsigned int : 4个字节
     long:   8个字节 范围  -9223372036854775808～9223372036854775807
     long long:  8个字节 范围  -9223372036854775808～9223372036854775807
     unsigned long long:  8个字节    最大值：1844674407370955161
     float:  4个字节
     double:  8个字节
     
     */
    Model *objc = [[Model alloc] init];
    objc.propertyOne = @"one";
    objc.propertyTwo = @"two";
    objc.num = 1;
    NSLog(@"objc对象实际需要的内存大小: %zd 字节", class_getInstanceSize([objc class]));
    NSLog(@"objc对象实际分配的内存大小: %zd 字节", malloc_size((__bridge const void *)(objc)));
    
    SonModel *sonModel = [[SonModel alloc]init];
    sonModel.PropertyThree = @"three";
    sonModel.PropertyFour = @"four";
    NSLog(@"sonModel对象实际需要的内存大小: %zd 字节", class_getInstanceSize([sonModel class]));
    NSLog(@"sonModel对象实际分配的内存大小: %zd 字节", malloc_size((__bridge const void *)(sonModel)));

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
