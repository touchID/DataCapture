
#import "NSString+Substring.h"
#import <Foundation/Foundation.h>
#import <DDLog.h>
#import <DDASLLogger.h>
#import <DDTTYLogger.h>
//#import <DDFileLogger.h>

static const int ddLogLevel = LOG_LEVEL_VERBOSE;// 定义日志级别

@interface LCWeek : NSObject
+(NSString *)weekdayStringFromDate:(NSDate *)inputDate;

@end

@implementation LCWeek

+(NSString *)weekdayStringFromDate:(NSDate *)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

@end



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        [DDLog addLogger:[DDTTYLogger sharedInstance]];// 初始化DDLog日志输出，在这里，我们仅仅希望在xCode控制台输出
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];// 启用颜色区分
//        DDLogError(@"错误信息"); // 红色
//        DDLogWarn(@"警告"); // 橙色
//        DDLogInfo(@"提示信息"); // 默认是黑色
//        DDLogVerbose(@"详细信息"); // 默认是黑色

        [DDLog addLogger:[DDASLLogger sharedInstance]];// 如果需要，可以添加其他的日志输出支持
        [[DDTTYLogger sharedInstance] setForegroundColor:nil backgroundColor:nil forFlag:LOG_FLAG_INFO];// 可以修改你想要的颜色
//        [[DDTTYLogger sharedInstance] setForegroundColor:[CIColor blueColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];// 可以修改你想要的颜色
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
        [dateFormatter2 setDateFormat:@"dd号"];
        NSString *leftStr = [NSString stringWithFormat:@"<dt>%@ %@</dt>",[dateFormatter2 stringFromDate:date], [LCWeek weekdayStringFromDate:[NSDate date]]];
        //@"<dt>24号 星期三</dt>"
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.zimuzu.tv/tv/eschedule"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *strHtml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        NSString *content = [strHtml substringWithinBoundsLeft:leftStr right:@"</dl>"];
        
        
        content = [[[[content
                      stringByReplacingOccurrencesOfString:@"\n" withString:@""]
                     stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"]
                    stringByReplacingOccurrencesOfString:@"<p>" withString:@""]
                   stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        DDLogVerbose(content);
//        NSArray *arr3 = [content componentsSeparatedByString:@"href"];
        
//                DDLogInfo(@"%@", arr3);
//        NSLog(@"%@", arr3);
        
    }
    return 0;
}
