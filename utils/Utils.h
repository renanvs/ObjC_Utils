//
//  Utils.h
//  PaleoProject
//
//  Created by renan veloso silva on 22/02/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Utils;

#define SynthensizeSingleTon(classname) \
static classname *shared##classname = nil; \
\
+ (classname *)sharedInstance \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\

#define debugAlert(message) \
[Utils debugAlert:(message)]

#define keyboardRect(notification) \
[Utils keyboardRectWithNotification:(notification)]

#define screenBounds() \
[Utils screenBoundsOnCurrentOrientation]

#define screenBoundsWidth() \
[Utils screenBoundsOnCurrentOrientation].size.width

#define SystemVersion() \
[Utils systemVersion]

#define PI 3.14159265358979 /* pi */
#define Degrees_To_Radians(angle) (angle / 180.0 * PI)

#define isPortrait() \
[Utils isPortrait]

#define isiPhone3_5_inch  ([[UIScreen mainScreen] bounds].size.height == 480)?TRUE:FALSE

#define isiPhone6Model  ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE

#define isiPhone6PlusModel  ([[UIScreen mainScreen] bounds].size.height == 736)?TRUE:FALSE

#define isiPad() \
[Utils isiPad]

@interface Utils : NSObject

+ (Utils *) sharedInstance;

+(BOOL)isiPad;

+(void)showFonts;

-(NSString*)getSafeLiteralString:(NSString*)text;

+(UIWindow*)getCurrentWindow;

+(CGRect) screenBoundsOnCurrentOrientation;

+(BOOL)isValidMail:(NSString*)mail;

+(UIInterfaceOrientation)getDeviceOrientation;

+(void)debugAlert:(NSString*)message;

+(CGRect)keyboardRectWithNotification:(NSNotification*)notification;

+(id)loadNibForName:(NSString*)nibName;

+(void)openPhone:(NSString*)phone;

+(float)systemVersion;

+(CGSize)getProportionalSize:(CGSize)size ByWidth:(CGFloat)width;
+(CGSize)getProportionalSize:(CGSize)size ByHeight:(CGFloat)height;

+(BOOL)IsiPhone3_5_inch;
+(BOOL)IsiPhone6Model;
+(BOOL)IsiPhone6PlusModel;

+(void)openUrlStringInNativeBrowse:(NSString*)urlSrt;

+(BOOL)isValidLatitude:(double)latitude AndLongitude:(double)longitude;

@end

@interface NSString (custom)

+ (BOOL)isStringEmpty:(NSString *)string;
+ (BOOL)isStringWithNumeric:(NSString*)string;
-(BOOL)isEmpty;
-(NSString*)removeLastChar;
-(NSString*)removeSpecialChars;
-(BOOL)containsThisChar:(NSString*)charStr;
-(NSString *)MD5String;
-(NSString*)getCharsQtd:(int)qtd;
+(void)openUrlStringInNativeBrowse:(NSString*)urlSrt;
-(NSString*)firstLetterToUppercase;

+ (NSString*)encodeToBase64:(NSString*)value;
+ (NSString*)decodeFromBase64:(NSString*)value;

@end

@interface UIView (Additions)

-(void)centerHorizontal;

-(void)centerVertical;

-(void)centerHorizontalWithSuperView:(UIView*)sv;

-(void)centerWithSuperView:(UIView*)sv;

-(void)centerInSuperview;

-(void) setX:(float) newX;
-(float)x;

-(void) setY:(float) newY;
-(float)y;

-(void) setWidth:(CGFloat) newWidth;
-(CGFloat)widthSize;

-(void) setHeight:(CGFloat) newHeight;
-(CGFloat)height;

-(void)setSize:(CGSize)newSize;

-(void)removeSubviews;

-(UIView *)viewWithUniqueTag:(NSInteger)tag;

-(void)clearColor;

@end

@interface UIResponder (Aditions)

-(UIViewController *) findTopRootViewController;

@end

@interface NSMutableDictionary(Add)

-(void)setString:(NSString*)string forKey:(id<NSCopying>)aKey;

@end

@interface UILabel (Aditions)

-(CGSize)sizeOfMultiLineLabel;

-(void)multiLineLabelAdjust;

@end

@interface UIColor (Aditions)

+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (UIColor*)changeBrightness:(UIColor*)color amount:(CGFloat)amount;

@end

@interface NSDictionary (Aditions)

-(BOOL)isEmptyDictionary;
+(BOOL)isEmptyDictionary:(id)dicObject;
-(BOOL)existThisKey:(NSString*)key;

-(NSString*)safeStringForKey:(NSString*)string;
-(NSNumber*)safeNumberForKey:(NSString*)string;

@end

@interface UIImage (Aditions)

+(UIImage *)inverseColor:(UIImage*)originalImage;
+ (UIImage *)image:(UIImage*)img withColor:(UIColor *)color;
+(UIImage *)imageTintedWithColor:(UIColor *)color WithImage:(UIImage*)originalImage;
+(UIImage *)compressImage:(UIImage *)image;

@end

@interface NSArray (Aditions)

-(NSArray*)justFirstItens:(int)index;

@end

@interface NSURLRequest (Aditions)

+(NSURLRequest*)requestWithString:(NSString*)urlStr;

@end

@interface UIWebView (Aditions)

-(void)loadRequestString:(NSString *)requestStr;

@end