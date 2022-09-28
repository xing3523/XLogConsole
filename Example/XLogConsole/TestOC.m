//
//  TestOC.m
//  XLogConsole_Example
//
//  Created by Xing on 2022/9/24.
//

#import "TestOC.h"

@import XLogConsole;

@implementation TestOC

+ (void)logTest {
	XLog(@"logTestOC1 class method")
	XLogWarn(@"logTestOC1 warn class method")
	XLogWarn(@"log %@", @"warn")
}

- (void)logTestWithName:(NSString *)name {
	XLogWarnWithName(name,@"logTestOC2 with name, instance method")
	XLogErrorWithName(name,@"logTestOC2 with name, instance method")
}

@end
