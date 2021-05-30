#import <WebKit/WebKit.h>

/*### WKWebView - start ###*/

@interface WKWebView(SynchronousEvaluateJavaScript)

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;

@end

/*### WKWebView - end ###*/
