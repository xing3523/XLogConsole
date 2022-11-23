//
//  TestOC.m
//  XLogConsole_Example
//
//  Created by Xing on 2022/9/24.
//

#import "TestOC.h"

#define UseSPM 0

#if UseSPM

#define XLog(fmt, ...) [XLogger log:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:nil :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];
#define XLogWithName(_name,fmt, ...) [XLogger log:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:_name :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];

#define XLogWarn(fmt, ...) [XLogger logWarn:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:nil :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];
#define XLogWarnWithName(_name,fmt, ...) [XLogger logWarn:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:_name :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];

#define XLogError(fmt, ...) [XLogger logError:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:nil :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];
#define XLogErrorWithName(_name,fmt, ...) [XLogger logError:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:_name :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];

#endif
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
