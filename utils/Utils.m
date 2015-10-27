//
//  Utils.m
//  PaleoProject
//
//  Created by renan veloso silva on 22/02/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CoreImage/CoreImage.h>

@implementation Utils

#pragma mark - initial method's

static id _instance;
+ (Utils *) sharedInstance{
    @synchronized(self){
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

+(void)showFonts{
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

+(BOOL)isValidMail:(NSString*)mail{
    if ([NSString isStringEmpty:mail]) {
        return NO;
    }
    
    NSRange rangemail0 = [mail rangeOfString:@"@"];
    NSRange rangemail1 = [mail rangeOfString:@"."];
    
    if (rangemail0.length <= 0 || rangemail1.length <= 0 ) {
        return NO;
    }
    
    return YES;
}

+(BOOL)isiPad{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    
    return NO;
}

+(void)openUrlStringInNativeBrowse:(NSString*)urlSrt{
    if ([NSString isStringEmpty:urlSrt]) {
        return;
    }
    
    NSRange rangewww = [urlSrt rangeOfString:@"www"];
    NSRange rangehttp = [urlSrt rangeOfString:@"http"];
    
    if (rangewww.length <= 0) {
        urlSrt = [urlSrt stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        urlSrt = [NSString stringWithFormat:@"http://www.%@",urlSrt];
    }else if(rangewww.length >0 && rangehttp.length <= 0){
        urlSrt = [NSString stringWithFormat:@"http://%@",urlSrt];
    }
    
    NSArray *components = [urlSrt componentsSeparatedByString:@"."];
    if (components.count > 4) {
        urlSrt = [urlSrt stringByReplacingOccurrencesOfString:@"http://www." withString:@"http://"];
    }
    
    NSURL *url = [NSURL URLWithString:urlSrt];
    
    [[UIApplication sharedApplication] openURL:url];
}

+(BOOL)isValidLatitude:(double)latitude AndLongitude:(double)longitude{
    if (latitude < -90 || latitude > 90 ||
        longitude < -180 || longitude > 180 ||
        latitude == 0 || longitude == 0) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - NSString auxiliar

//retorna uma NSString minuscula e sem acento
-(NSString*)getSafeLiteralString:(NSString*)text{
    NSDictionary *typeA= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"ã", @"â", @"á", @"à", nil] forKey:@"a"];
    NSDictionary *typeE= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"é", @"ê", @"è", nil] forKey:@"e"];
    NSDictionary *typeI= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"í", @"î", @"ì", nil] forKey:@"i"];
    NSDictionary *typeO= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"ó", @"ô", @"ò", @"õ", nil] forKey:@"o"];
    NSDictionary *typeU= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"ú", @"û", @"ù", nil] forKey:@"u"];
    NSDictionary *typeC= [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"ç", nil] forKey:@"c"];
    NSArray *listType = [NSArray arrayWithObjects:typeA, typeE, typeI, typeO, typeU, typeC, nil];
    
    text = [text lowercaseString];
    for (NSDictionary *dic in listType) {
        NSString *key = [[dic allKeys] lastObject];
        NSArray *array = [dic objectForKey:key];
        for (NSString *charValue in array) {
            NSRange range = [text rangeOfString:charValue];
            if (range.length > 0) {
                text = [text stringByReplacingOccurrencesOfString:charValue withString:key];
            }
            
        }
    }
    
    return text;
    
}

//Pega o tamanho da tela na orientação atual
+(CGRect) screenBoundsOnCurrentOrientation{
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    

    if (SystemVersion() >= 8) {
        return screenBounds;
    }
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        screenBounds.size = CGSizeMake(width, height);
    }else if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        screenBounds.size = CGSizeMake(height, width);
    }
    return screenBounds ;
}

//retorna a orientação atual do Device
+(UIInterfaceOrientation)getDeviceOrientation{
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    return interfaceOrientation;
}

+(BOOL)IsiPhone3_5_inch{
    return isiPhone3_5_inch;
}

+(BOOL)IsiPhone6Model{
    return isiPhone6Model;
}

+(BOOL)IsiPhone6PlusModel{
    return isiPhone6PlusModel;
}

//Chama um alert com a mensagem passada
+(void)debugAlert:(NSString*)message{
    [[[UIAlertView alloc] initWithTitle:@"Debug" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
}

+(CGRect)keyboardRectWithNotification:(NSNotification*)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGRect screenSize = screenBounds();
    CGFloat screenHeight = screenSize.size.height;
    
    keyboardFrameBeginRect.origin.y = screenHeight - keyboardFrameBeginRect.size.height;
    
    return keyboardFrameBeginRect;
}

+(id)loadNibForName:(NSString *)nibName{
    NSArray *list = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    if (list) {
        return  [list lastObject];
    }
    
    return nil;
}

+(float)systemVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+(BOOL)isPortrait{
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return NO;
    }
    else if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return YES;
    }
    return NO;
}

+(CGSize)getProportionalSize:(CGSize)size ByHeight:(CGFloat)height{
    CGFloat width = (height * size.width)/size.height;
    return CGSizeMake(width, height);
}

+(CGSize)getProportionalSize:(CGSize)size ByWidth:(CGFloat)width{
    CGFloat height = (width * size.height)/size.width;
    return CGSizeMake(width, height);
}

@end

@implementation UIView (Additions)

//centraliza a view horizontalmente em relação a view pai
-(void)centerHorizontal{
    [self setX:([self.superview widthSize]/2)- ([self widthSize]/2)];
}

//centraliza a view verticalmente em relação a view pai
-(void)centerVertical{
    [self setY:([self.superview height]/2)- ([self height]/2)];
}

//centraliza a view em relação a view pai
-(void)centerInSuperview{
    [self centerHorizontal];
    [self centerVertical];
}

-(void)setX:(float)newX{
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

-(float)x{
    return self.frame.origin.x;
}

-(void) setY:(float) newY{
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}
-(float)y{
    return self.frame.origin.y;
}

-(void) setWidth:(float) newWidth{
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}
-(float)widthSize{
    return self.frame.size.width;
}

-(void) setHeight:(float) newHeight{
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}
-(float)height{
    return self.frame.size.height;
}

-(void)setSize:(CGSize)newSize{
    CGRect rect = self.frame;
    rect.size = newSize;
    self.frame = rect;
}

-(void)removeSubviews{
    for (id obj in self.subviews) {
        [obj removeFromSuperview];
    }
}

-(UIView *)viewWithUniqueTag:(NSInteger)tag{
    for (UIView *view in self.subviews) {
        NSInteger tagF = view.tag;
        if (tagF == tag) {
            return view;
        }
    }
    
    return [self viewWithTag:tag];
}

-(void)clearColor{
    self.backgroundColor = [UIColor clearColor];
}

@end

@implementation UIResponder (Aditions)
-(UIViewController *) findTopRootViewController {
	UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
	
	if (topWindow.windowLevel != UIWindowLevelNormal) {
		NSArray *windows = [[UIApplication sharedApplication] windows];
		
		for(topWindow in windows) {
			if (topWindow.windowLevel == UIWindowLevelNormal) {
				break;
			}
		}
	}
	
    UIView *rootView = nil;
    
    if ([[topWindow subviews] count] != 0){
        rootView = [[topWindow subviews] objectAtIndex:0];
    }
    
	id nextResponder = [rootView nextResponder];
	
	return [nextResponder isKindOfClass:[UIViewController class]]
	? nextResponder
	: nil;
}
@end

@implementation NSMutableDictionary(Add)

-(void)setString:(NSString*)string forKey:(id<NSCopying>)aKey{
    if ([NSString isStringEmpty:string]) {
        string = @"";
    }
    [self setObject:string forKey:aKey];
}

@end

@implementation NSString (JRAdditions)

+ (BOOL)isStringEmpty:(NSString *)string {
    if([string length] == 0) { //string is empty or nil
        return YES;
    }
    
    if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}

-(BOOL)isEmpty{
    if ([NSString isStringEmpty:self]) {
        return YES;
    }
    
    return NO;
}

-(NSString *)removeLastChar{
    return [self substringToIndex:self.length-1];
}

-(BOOL)containsThisChar:(NSString*)charStr{
    NSRange range = [self rangeOfString:charStr];
    if (range.length > 0) {
        return YES;
    }
    return NO;
}

-(NSString*)removeSpecialChars{
    NSString *string = self;
    
    if ([NSString isStringEmpty:self]) {
        return @"";
    }
    
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"!" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"@" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"$" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"%" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"^" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"*" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"_" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"=" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"~" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"`" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"[" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"{" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"}" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"]" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@":" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@";" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"?" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"’" withString:@""];
    
    return string;
}


+ (BOOL)isStringWithNumeric:(NSString*)string{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:string];
    bool status = number != nil;
    
    return status;
}

- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

//+ (NSString*)encodeToBase64:(NSString*)value{
//    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
//    //NSString *encoded = [data base64EncodedStringWithOptions:0];
//    NSString *encoded = [data base64EncodedString];
//    
//    return encoded;
//}
//+ (NSString*)decodeFromBase64:(NSString*)value;{
//    NSData *data = [[NSData alloc] initWithBase64EncodedString:value options:0];
//    NSString *decoded = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return decoded;
//}

-(NSString*)getCharsQtd:(int)qtd{
    NSString *text = self;
    
    if (text.length < qtd) {
        return self;
    }
    
    NSRange range;
    range.length = qtd;
    range.location = 0;
    
    text = [text substringWithRange:range];
    
    return text;
}

-(NSString*)firstLetterToUppercase{
    NSString *toChange = self;
    
    toChange = [toChange lowercaseString];
    
    /* create a locale where diacritic marks are not considered important, e.g. US English */
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    
    /* get first char */
    NSString *firstChar = [toChange substringToIndex:1];
    
    /* remove any diacritic mark */
    NSString *folded = [firstChar stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:locale];
    
    /* create the new string */
    NSString *result = [[folded uppercaseString] stringByAppendingString:[toChange substringFromIndex:1]];
    
    return result;
}


@end

@implementation UIColor (Aditions)

+ (UIColor*)changeBrightness:(UIColor*)color amount:(CGFloat)amount{
    
    CGFloat hue, saturation, brightness, alpha;
    if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        brightness += (amount-1.0);
        brightness = MAX(MIN(brightness, 1.0), 0.0);
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    }
    
    CGFloat white;
    if ([color getWhite:&white alpha:&alpha]) {
        white += (amount-1.0);
        white = MAX(MIN(white, 1.0), 0.0);
        return [UIColor colorWithWhite:white alpha:alpha];
    }
    
    return nil;
}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end

@implementation UILabel (Aditions)

-(CGSize)sizeOfMultiLineLabel{
    
    NSAssert(self, @"UILabel was nil");
    
    //Label text
    NSString *aLabelTextString = [self text];
    
    //Label font
    UIFont *aLabelFont = [self font];
    
    //Width of the Label
    CGFloat aLabelSizeWidth = self.frame.size.width;
    
    
    if (SystemVersion() < 7) {
        //version < 7.0
        
        CGSize size = [aLabelTextString sizeWithFont:aLabelFont
                                   constrainedToSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
        size.height += 1;
        return size;
    }
    else if (SystemVersion() >= 7) {
        //version >= 7.0
        
        //Return the calculated size of the Label
        CGSize size = [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{
                                                               NSFontAttributeName : aLabelFont
                                                               }
                                                     context:nil].size;
        size.height += 1;
        return size;
        
    }
    
    return [self bounds].size;
    
}

-(void)multiLineLabelAdjust{
    CGSize size = [self sizeOfMultiLineLabel];
    [self setHeight:size.height];
}

@end

@implementation NSDictionary (Aditions)

-(BOOL)isEmptyDictionary{
    NSArray *list = [self allKeys];
    if (list.count == 0) {
        return YES;
    }
    return NO;
}

+(BOOL)isEmptyDictionary:(id)dicObject{
    if (!dicObject) {
        return YES;
    }
    
    if ([dicObject isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

-(BOOL)existThisKey:(NSString*)key{
    NSArray *listKeys = [self allKeys];
    for (NSString *keyC in listKeys) {
        if ([key isEqualToString:keyC]) {
            return YES;
        }
    }
    return NO;
}

-(NSString*)safeStringForKey:(NSString*)string{
    id obj = [self objectForKey:string];
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *str = (NSString*)obj;
        if (![NSString isStringEmpty:str]) {
            return str;
        }else{
            return @"";
        }
    }
    return @"";
}

-(NSNumber*)safeNumberForKey:(NSString*)string{
    id obj = [self objectForKey:string];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)obj;
    }
    return @0;
}

@end


@implementation UIImage (Aditions)

+(UIImage *)inverseColor:(UIImage*)originalImage{
    UIGraphicsBeginImageContext(originalImage.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    CGRect imageRect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    [originalImage drawInRect:imageRect];
    
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, originalImage.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    //mask the image
    CGContextClipToMask(UIGraphicsGetCurrentContext(), imageRect,  originalImage.CGImage);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, originalImage.size.width, originalImage.size.height));
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return returnImage;
}


+(UIImage *)imageTintedWithColor:(UIColor *)color WithImage:(UIImage*)originalImage{
    if (color) {
        // Construct new image the same size as this one.
        UIImage *image;
        UIGraphicsBeginImageContextWithOptions([originalImage size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
        CGRect rect = CGRectZero;
        rect.size = [originalImage size];
        
        // tint the image
        [originalImage drawInRect:rect];
        [color set];
        UIRectFillUsingBlendMode(rect, kCGBlendModeScreen);
        
        // restore alpha channel
        [originalImage drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    return originalImage;
}

+(UIImage *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}

@end

@implementation NSArray (Aditions)

-(NSArray*)justFirstItens:(int)index{
    int i = index;
    if (self.count < index) {
        i = self.count;
    }
    
    NSMutableArray *listM = [NSMutableArray array];
    for (int y=0; y<i; y++) {
        [listM addObject:[self objectAtIndex:y]];
    }
    
    return listM;
}

@end

@implementation NSURLRequest (Aditions)

+(NSURLRequest*)requestWithString:(NSString*)urlStr{
    NSURL *urlObject = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlObject];
    return request;
}

@end

@implementation UIWebView (Aditions)

-(void)loadRequestString:(NSString *)requestStr{
    [self loadRequest:[NSURLRequest requestWithString:requestStr]];
}

@end