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
    
//    [self objectExplore];
//    [self propertyExplore];
    
    [self updatePropertyExplore];
    [self updateMethodExplore];
}

- (void)updateMethodExplore{
    /** 
     * Adds a new method to a class with a given name and implementation.
     * 
     * @param cls The class to which to add a method.//添加方法名字
     * @param name A selector that specifies the name of the method being added.//方法名称
     * @param imp A function which is the implementation of the new method. The function must take at least two arguments—self and _cmd.//方法的实现必须至少2个参数,self 和 _cmd
     * @param types An array of characters that describe the types of the arguments to the method. //描述
     * 
     * @return YES if the method was added successfully, otherwise NO   //y成功,n失败
     *  (for example, the class already contains a method implementation with that name).
     *
     * @note class_addMethod will add an override of a superclass's implementation, //会覆盖superclass 的实现;
     *  but will not replace an existing implementation in this class. //已经存在的不会替换
     *  To change an existing implementation, use method_setImplementation.//想要改变,使用method_setImplementation方法
     */
//    OBJC_EXPORT BOOL class_addMethod(Class cls, SEL name, IMP imp,
//                                     const char *types)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0);
    //其中 “v@:” 表示返回值和参数
    
    if(class_addMethod([Model class],  NSSelectorFromString(@"addInstance"), (IMP)addInstanceGetter, "@@:"))
    {
        NSLog(@"addInstance get 方法添加成功");
    }
    else
    {
        NSLog(@"addInstance get 方法添加失败");
    }
    
    if(class_addMethod([Model class], NSSelectorFromString(@"setAddInstance:"), (IMP)addInstanceSetter, "v@:@"))
    {
        NSLog(@"setAddInstance set 方法添加成功");
    }
    else
    {
        NSLog(@"setAddInstance set 方法添加失败");
    }
    
    
    if(class_addMethod([Model class],  NSSelectorFromString(@"addProperty"), (IMP)addPropertyGetter, "@@:"))
    {
        NSLog(@"addInstance get 方法添加成功");
    }
    else
    {
        NSLog(@"addInstance get 方法添加失败");
    }
    
    if(class_addMethod([Model class], NSSelectorFromString(@"addProperty:"), (IMP)addPropertySetter, "v@:@"))
    {
        NSLog(@"setAddInstance set 方法添加成功");
    }
    else
    {
        NSLog(@"setAddInstance set 方法添加失败");
    }
    [self MethodExplore];
    
}


NSString *addInstanceGetter(id self, SEL _cmd){
    Ivar ivar = class_getInstanceVariable([Model class], "_addInstance");
    return object_getIvar(self, ivar);
}

void addInstanceSetter(id self, SEL _cmd, NSString *newValue){
    Ivar ivar = class_getInstanceVariable([Model class], "_addInstance");
    id oldVaule = object_getIvar(self , ivar);
    if (oldVaule != newValue) {
        object_setIvar(self, ivar, [newValue copy]);
    }
}


NSString *addPropertyGetter(id self, SEL _cmd){
    Ivar ivar = class_getInstanceVariable([Model class], "addProperty");
    return object_getIvar(self, ivar);
}

void addPropertySetter(id self, SEL _cmd, NSString *newValue){
    Ivar ivar = class_getInstanceVariable([Model class], "addProperty");
    id oldVaule = object_getIvar(self , ivar);
    if (oldVaule != newValue) {
        object_setIvar(self, ivar, [newValue copy]);
    }
}
- (void)updatePropertyExplore{
    /**
     * Adds a property to a class.
     *
     * @param cls 修改的类
     * @param name 属性名字
     * @param attributes 属性数组
     * @param attributeCount 属性数组数量
     * @return y 成功,n失败
     */
//    OBJC_EXPORT BOOL class_addProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount)
//    OBJC_AVAILABLE(10.7, 4.3, 9.0, 1.0);
    
    objc_property_attribute_t type = {"T","@\"NSString\""};
    objc_property_attribute_t ownership = {"C",""};
    objc_property_attribute_t nonatomic = {"N",""};
    objc_property_attribute_t backingivar = {"V","_addInstance"};
    objc_property_attribute_t backingProperty = {"V","addProperty"};
    objc_property_attribute_t attrs[] = {type,ownership,nonatomic,backingivar};
    
    class_addProperty([Model class], "addInstance", attrs, 4);

    
    objc_property_attribute_t attrsProperty[] = {type,ownership,nonatomic,backingProperty};
    class_addProperty([Model class], "addProperty", attrsProperty, 4);
    /**
    对比新增成员变量和实例变量
    propertyName  addProperty
    propertyInfo  T@"NSString",C,N,VaddProperty

    propertyName  addInstance
    propertyInfo  T@"NSString",C,N,V_addInstance
     */
    [self propertyExplore];
}
- (void)MethodExplore{
    unsigned int methodCount;
    NSMutableArray *methodList = [NSMutableArray array];
    Method *methods = class_copyMethodList([Model class], &methodCount);
    for (int i = 0; i < methodCount; i++) {
        SEL  selName = method_getName(methods[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(selName) encoding:(NSUTF8StringEncoding)];
        [methodList addObject:strName];
    }
    
    free(methods);
    
    NSLog(@"%@",methodList);
    /**
     (
     "setPropertyOne:",
     "setPropertyTwo:",
     "setNum:",
     "setPropertyThree:",
     "setPropertyFour:",
     modelName,
     modelNameTest,
     propertyOne,
     propertyTwo,
     PropertyThree,
     PropertyFour,
     num,
     priv,
     "setPriv:",
     ".cxx_destruct" //在ARC模式下，将所有的成员变量变成nil相当于MRC模式下的dealloc
     )
     */
    
}
- (void)propertyExplore{
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([Model class], &count);
    for (unsigned int i = 0; i <count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"propertyName  %@",[NSString stringWithUTF8String:propertyName]);
        objc_property_t property = propertyList[i];
        
        const char *propertyInfo = property_getAttributes(property);
        
        NSLog(@"propertyInfo  %@",[NSString stringWithUTF8String:propertyInfo]);
    }
    
    /**
     log
    propertyName  priv
    propertyInfo  T@"NSString",C,N,V_priv
    propertyName  propertyOne
    propertyInfo  T@"NSString",C,N,V_propertyOne
    propertyName  propertyTwo
    propertyInfo  T@"NSString",C,N,V_propertyTwo
    propertyName  PropertyThree
    propertyInfo  T@"NSString",C,N,V_PropertyThree
    propertyName  PropertyFour
    propertyInfo  T@"NSString",C,N,V_PropertyFour
    propertyName  num
    propertyInfo  Ti,N,V_num
     
     释义：T@"NSString", C,            N,           V_propertyOne
            类型NSString,关键字Copy,关键字nonatomic,实例变量_propertyOne
     https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
     
     R The property is read-only (readonly).
     
     C The property is a copy of the value last assigned (copy).
     
     & The property is a reference to the value last assigned (retain).
     
     N The property is non-atomic (nonatomic).
     
     G<name>  The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
     
     S<name> The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
     
     D The property is dynamic (@dynamic).
     
     W The property is a weak reference (__weak).
     
     P The property is eligible for garbage collection.
     
     t<encoding> Specifies the type using old-style encoding.
     */
   
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
