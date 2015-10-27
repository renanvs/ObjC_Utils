//
//  PhoneField.h
//  VET
//
//  Created by renan veloso silva on 9/13/14.
//  Copyright (c) 2014 renanvs. All rights reserved.
//

/*
    Essa classe é uma extensão do UITextField apenas para telefone e celular,
*/

#import <UIKit/UIKit.h>

@class PhoneField;
@protocol PhoneFieldDelegate <NSObject>

@optional
-(void)PhoneFieldError:(NSString*)errorDescription StringField:(PhoneField*)field;
-(void)PhoneFieldDidBeginEditing:(PhoneField*)field;
-(void)PhoneFieldKeyboarkOkPressed:(PhoneField*)field;
@end

@interface PhoneField : UITextField <UITextFieldDelegate>{
    id delegatePhone;
    BOOL inside;
    NSString *stringInside;
}

+(NSString*)textWithoutFormat:(NSString*)string;
-(BOOL)isValidPhone;

@property(nonatomic) id delegatePhone;
@property(nonatomic) BOOL hasError;

@end
