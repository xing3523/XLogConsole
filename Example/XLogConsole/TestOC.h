//
//  TestOC.h
//  XLogConsole_Example
//
//  Created by Xing on 2022/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestOC : NSObject
+ (void)logTest;
- (void)logTestWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
