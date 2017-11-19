//
//  TestCoreDataEntity5+CoreDataProperties.h
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 4/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

#import "TestCoreDataEntity5+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TestCoreDataEntity5 (CoreDataProperties)

+ (NSFetchRequest<TestCoreDataEntity5 *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *attribute1;
@property (nullable, nonatomic, copy) NSNumber *attribute2;
@property (nullable, nonatomic, retain) TestCoreDataEntity4 *entity4ToOne;
@property (nullable, nonatomic, retain) TestCoreDataEntity4 *entity4ToMany;

@end

NS_ASSUME_NONNULL_END
