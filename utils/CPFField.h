//
//  CPFField.h
//  Soho
//
//  Created by renanvs on 10/26/15.
//  Copyright © 2015 lookr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPFField;
@protocol CPFFieldDelegate <NSObject>

@optional
-(void)CPFFieldKeyboarkOkPressed:(CPFField*)field;

@end

@interface CPFField : UITextField<UITextFieldDelegate>{
    NSString *textWithoutFormat;
    id<CPFFieldDelegate> delegateCpf;
}

@property (strong, nonatomic) NSString *labelValue;
@property (nonatomic, strong, readonly) NSString *textWithoutFormat;
@property (nonatomic) id<CPFFieldDelegate> delegateCpf;

-(void)setPlaceholder:(NSString *)_placeholder;
-(BOOL)isValidCpf;

@end