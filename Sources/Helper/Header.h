//
//  Header.h
//  Pods
//
//  Created by xing on 2022/9/28.
//

#ifndef Header_h
#define Header_h

#define XLog(fmt, ...) [XLogger log:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:nil :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];
#define XLogWithName(_name,fmt, ...) [XLogger log:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:_name :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];

#define XLogWarn(fmt, ...) [XLogger logWarn:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:nil :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];
#define XLogWarnWithName(_name,fmt, ...) [XLogger logWarn:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:_name :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];

#define XLogError(fmt, ...) [XLogger logError:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:nil :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];
#define XLogErrorWithName(_name,fmt, ...) [XLogger logError:[NSString stringWithFormat:fmt,##__VA_ARGS__] name:_name :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];

#endif /* Header_h */
