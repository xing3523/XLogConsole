//
//  Marco.h
//  XLogConsole
//
//  Created by Xing on 2022/9/24.
//

#ifndef Marco_h
#define Marco_h

#define XLog(_log) XLogWithName(_log,nil)
#define XLogWithName(_log,_name) [Logger log:_log name:_name :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];

#define XLogWarn(_log) XLogWarnWithName(_log,nil)
#define XLogWarnWithName(_log,_name) [Logger logWarn:_log name:_name :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];

#define XLogError(_log) XLogErrorWithName(_log,nil)
#define XLogErrorWithName(_log,_name) [Logger logError:_log name:_name :@"" :[NSString stringWithFormat:@"%s",__func__] :__LINE__];


#endif /* Marco_h */
