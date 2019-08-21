//
//  Model.h
//  OC
//
//  Created by conan on 2019/8/21.
//  Copyright © 2019年 conan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic, copy) NSString *propertyOne;
@property (nonatomic, copy) NSString *propertyTwo;
@property (nonatomic, copy) NSString *PropertyThree;
@property (nonatomic, copy) NSString *PropertyFour;

@property (nonatomic, assign) int num;

- (void)modelName;

@end
