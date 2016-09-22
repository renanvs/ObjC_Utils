//
//  GPSUtils.h
//  AppEvento
//
//  Created by renan veloso silva on 1/23/15.
//  Copyright (c) 2015 renanvs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    NavigationTypeAppleMaps     = 0,
    NavigationTypeWaze          = 1,
    NavigationTypeGoogleMaps    = 2
} NavigationType;

@interface GPSUtils : NSObject

+(NSArray*)getListPossibleGPSNavigation;

+(void)navigateWithLatitude:(float)latitude AndLongitude:(float)longitude WithNavigationType:(NavigationType)navigationType;

+(BOOL)canUseAppleMaps;
+(BOOL)canUseGoogleMaps;
+(BOOL)canUseWaze;

+(NSArray*)getListPossibleGPSNavigationType;

@end
