//
//  WKWebViewExtension.m
//  HelloCordova
//
//  Created by Ifthikhar Ahamed on 29/05/21.
//

#import <WebKit/WebKit.h>

/*### WKWebView - start ###*/

@implementation WKWebView(SynchronousEvaluateJavaScript)

 

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script

{

    __block NSString *resultString = nil;

    __block BOOL finished = NO;

 

    [self evaluateJavaScript:script completionHandler:^(id result, NSError *error) {

        if (error == nil) {

            if (result != nil) {

                resultString = [NSString stringWithFormat:@"%@", result];

            }

        } else {

            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);

        }

        finished = YES;

    }];

 

    while (!finished)

    {

        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

    }

 

    return resultString;

}

@end

/*### WKWebView - end ###*/
