

 

//

//  AppDelegate.m

//  GDRemarkableSalesAutomation

//

//  Created by ___FULLUSERNAME___ on ___DATE___.

//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.

//

 

#import "AppDelegate.h"

#import "MainViewController.h"

#import "WKWebViewExtension.h"

@implementation AppDelegate

    

@synthesize window, viewController;

    

- (id) init

{

    /** If you need to do any extra app-specific initialization, you can do it here

     *  -jm

     **/

    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

        

    // Rob    [CDVURLProtocol registerURLProtocol];

        

    return [super init];

}

 

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions

{

//

    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    

#if __has_feature(objc_arc)

    self.window = [[UIWindow alloc] initWithFrame:screenBounds];

#else

    self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];

#endif

    self.window.autoresizesSubviews = YES;

    

#if __has_feature(objc_arc)

    self.viewController = [[MainViewController alloc] init];

#else

    self.viewController = [[[MainViewController alloc] init] autorelease];

#endif

    

    self.window = [[UIWindow alloc] initWithFrame:screenBounds];

    self.window.autoresizesSubviews = YES;

    

    CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];

    

    self.viewController = [[MainViewController alloc] init];

    

#if defined(DEBUG) || defined(DEV_RELEASE)

    self.viewController.wwwFolderName = @"www";

#else

    self.viewController.wwwFolderName = nil;

 #endif

    /*

    //EMEA UAT URL

//    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:@"https://uat.salesstationdevice.citigroup.com/jmvc/dsaemea/unsecured/home_screen.htm", @"appurl", nil];

    

    //BAU EMEA UAT URL

    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:@"https://uat.responsivesalesautomation.citigroup.com/jmvc/dsaemea/unsecured/home_screen.htm", @"appurl", nil];

    

    // Amit Local URL

    //NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:@"http://apachktpav5835.apac.nsroot.net:8080/jmvc/dsaemea/unsecured/home_screen_dummy.htm", @"appurl", nil];

    // senthil Local URL

    //NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:@"http://apsgitow7w0156.apac.nsroot.net:8080/jmvc/dsaemea/unsecured/home_screen_dummy.htm", @"appurl", nil];

    

    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

    [[NSUserDefaults standardUserDefaults] synchronize];

    

    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"appurl"];

    NSLog(@"path from the appdelegate :: %@ ::", name);

    

    //self.viewController.startPage = @"citiloginmanager/home_screen.html";

    self.viewController.startPage = [[NSUserDefaults standardUserDefaults] stringForKey:@"appurl"];*/

    //Extract the server URL from Settings.bundle and register in the User Defaults

    //The version value is set from shell script->Target->build phase->Run script

    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];

    NSString * appURL= @"https://uat.salesstationdevice.citigroup.com/jmvc/dsaemea/unsecured/home_screen.htm";

    

    if (!appURL) {

        [self registerDefaultsFromSettingsBundle];

        appURL= [stdDefaults objectForKey:@"appurl"];

    }

    NSLog(@"Server URL in app delegates:%@", appURL);

    

#if defined(DEBUG) || defined(DEV_RELEASE)

    self.viewController.startPage = @"https://uat2.directsalesautomation.citigroup.com/ubre/jmvc/dsare/unsecured/home_screen.htm";

#else

    self.viewController.startPage = appURL;

#endif

 

    self.viewController.view.frame = viewBounds;

    

    // check whether the current orientation is supported: if it is, keep it, rather than forcing a rotation

    UIDeviceOrientation curDevOrientation = [[UIDevice currentDevice] orientation];

    

    if (UIDeviceOrientationUnknown == curDevOrientation) {

        // UIDevice isn't firing orientation notifications yet… go look at the status bar

        curDevOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];

    }


    [self.window setRootViewController:self.viewController];

    [self.window makeKeyAndVisible];

    [self setStatusBarBackgroundColor:[UIColor colorWithWhite:2.0 alpha:1.0]];
    
    // calls into javascript global function 'handleOpenURL'
    NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", appURL];

           [(WKWebView*)self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];
    return YES;

}

 

//this method reads the settings bundle and transfers it content to NSUserDefaults

- (void)registerDefaultsFromSettingsBundle {

    // this function writes default settings as settings

    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];

    if(!settingsBundle) {

        NSLog(@"Could not find Settings.bundle");

        return;

    }

    

    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];

    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];

    

    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];

    for(NSDictionary *prefSpecification in preferences) {

        NSString *key = [prefSpecification objectForKey:@"Key"];

        if(key) {

            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];

            NSLog(@"writing as default %@ to the key %@",[prefSpecification objectForKey:@"DefaultValue"],key);

        }

    }

    

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];

    

}

 

// Required for GD if you are only supporting certain orientations

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window

{

    return UIInterfaceOrientationMaskLandscape;

}

    

// this happens while we are running ( in the background, or from within our own app )

// only valid if PluginUnitTest-Info.plist specifies a protocol to handle

- (BOOL) application:(UIApplication*)application handleOpenURL:(NSURL*)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation

    {

        if (!url) {

            return NO;

        }

        

        // calls into javascript global function 'handleOpenURL'
        NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];

               [(WKWebView*)self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];

        

        // all plugins will get the notification, and their handlers will be called

        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];

        

        return YES;

    }

 

- (void)applicationWillTerminate:(UIApplication *)application {

    

#ifdef DEBUG

    NSLog(@"Application will Terminate");

#endif

    

    UIPasteboard *pb = [UIPasteboard generalPasteboard];

    if(pb != NULL) {

        

        [pb setValue:@"" forPasteboardType:UIPasteboardNameGeneral];

    }

}

    

- (void)applicationDidEnterBackground:(UIApplication *)application {

    

#ifdef DEBUG

    NSLog(@"Set webview Hidden. No copy paste");

#endif

    

    UIPasteboard *pb = [UIPasteboard generalPasteboard];

    if(pb != NULL) {

        

        [pb setValue:@"" forPasteboardType:UIPasteboardNameGeneral];

    }

    

    [viewController webView].hidden = YES;

    

#ifdef DEBUG

    NSLog(@"Application entered Background");

#endif

    

}

    

- (void)applicationWillEnterForeground:(UIApplication *)application {

    

#ifdef DEBUG

    NSLog(@"Application entering Foreground");

#endif

    

    [viewController webView].hidden = NO;

}

    

- (void)setStatusBarBackgroundColor:(UIColor *)color {

    

     if (@available(iOS 13.0, *)) {

         UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication 　　　　sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;

         statusBar.backgroundColor = color;

         [[UIApplication sharedApplication].keyWindow addSubview:statusBar];

     } else {

         UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];

         if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {

             statusBar.backgroundColor = color;

             

         }

     }

}

 

@end
