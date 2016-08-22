//
//  GPSUtils.m
//  AppEvento
//
//  Created by renan veloso silva on 1/23/15.
//  Copyright (c) 2015 renanvs. All rights reserved.
//


#import "GPSUtils.h"
#import <MapKit/MapKit.h>

@implementation GPSUtils

+(BOOL)canUseWaze{
    return [self canUseThisUrl:@"waze://"];
}

+(BOOL)canUseAppleMaps{
    return [self canUseThisUrl:@"http://maps.apple.com/"];
}

+(BOOL)canUseGoogleMaps{
    return [self canUseThisUrl:@"comgooglemaps://"];
}

+(BOOL)canUseThisUrl:(NSString*)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        return YES;
    }
    return NO;
}

+(NSArray*)getListPossibleGPSNavigation{
    NSMutableArray *gpsList = [[NSMutableArray alloc] init];
    
    if ([self canUseAppleMaps]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:NavigationTypeAppleMaps] forKey:@"type"];
        [dic setObject:@"Apple Maps" forKey:@"title"];
        [gpsList addObject:dic];
    }
    
    if ([self canUseWaze]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:NavigationTypeWaze] forKey:@"type"];
        [dic setObject:@"Waze" forKey:@"title"];
        [gpsList addObject:dic];
    }
    
    if ([self canUseGoogleMaps]){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:NavigationTypeGoogleMaps] forKey:@"type"];
        [dic setObject:@"Google Maps" forKey:@"title"];
        [gpsList addObject:dic];
    }
    return gpsList;
}

+(void)navigateWithLatitude:(float)latitude AndLongitude:(float)longitude WithNavigationType:(NavigationType)navigationType{
    
    if (navigationType == NavigationTypeAppleMaps) {
        CLLocationCoordinate2D latLong = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: latLong addressDictionary: nil];
        MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
        destination.name = @"Name Here!";
        NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
        NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 MKLaunchOptionsDirectionsModeDriving,
                                 MKLaunchOptionsDirectionsModeKey, nil];
        [MKMapItem openMapsWithItems: items launchOptions: options];
    }
    
    if (navigationType == NavigationTypeWaze) {
        NSString *urlStr = [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",
         latitude, longitude];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    
    if (navigationType == NavigationTypeGoogleMaps) {
        NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f&views=traffic&directionsmode=driving&ll",latitude,longitude];
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlStr]];
    }
}


@end
