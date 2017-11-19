//
//  TestCoreDataEntity2+CoreDataProperties.h
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 4/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

#import "TestCoreDataEntity2+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TestCoreDataEntity2 (CoreDataProperties)

+ (NSFetchRequest<TestCoreDataEntity2 *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *attribute1;
@property (nullable, nonatomic, copy) NSNumber *attribute2;

@end

NS_ASSUME_NONNULL_END
