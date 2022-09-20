//
//  TestOC.m
//  XLogConsole_Example
//
//  Created by Xing on 2022/9/24.
//

#import "TestOC.h"
#import "XLogConsole_Example-Swift.h"
#import "Marco.h"
@implementation TestOC

+ (void)logTest {
    XLog(@"logTestOC1 class method");
	XLogWarn(@"logTestOC1 warn class method");
}

- (void)logTestWithName:(NSString *)name {
	XLogWarnWithName(@"logTestOC2 with name, instance method", name);
    XLogErrorWithName(@"logTestOC2 with name, instance method", name);
}

@end
