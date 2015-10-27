//
//  CPFField.m
//  Soho
//
//  Created by renanvs on 10/26/15.
//  Copyright © 2015 lookr. All rights reserved.
//

#import "CPFField.h"
#import "Utils.h"

@implementation CPFField
@synthesize labelValue, delegateCpf;

-(void)setPlaceholder:(NSString *)_placeholder{
    [self setPlaceholder:_placeholder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([delegateCpf respondsToSelector:@selector(CPFFieldKeyboarkOkPressed:)]){
        [delegateCpf CPFFieldKeyboarkOkPressed:self];
    }
//    [textField resignFirstResponder];
    return YES;
}

-(BOOL)isValidCpf{
    if ([NSString isStringEmpty:self.text]) {
        return NO;
    }
    
    BOOL vCharCount = self.text.length == 14 ? YES : NO;
    NSMutableString *strM = [NSMutableString stringWithString:self.text];
    int numberOfPoints =  (int)[strM replaceOccurrencesOfString:@"." withString:@"" options:NSLiteralSearch range:NSMakeRange(0, self.text.length)];
    BOOL vPointCount = numberOfPoints == 2 ? YES : NO;
    BOOL vTraceCount = [self.text containsThisChar:@"-"] ? YES : NO;
    
    if (vCharCount && vPointCount && vTraceCount){
        return YES;
    }
    return NO;
}

-(BOOL)formatCpfTextField:(UITextField*)textField Range:(NSRange)range String:(NSString*)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (range.length > 1 || ![NSString isStringWithNumeric:string] || string.length > 1) {
        return NO;
    }
    
    int location = (int)range.location;
    
    if (location == 3 || location == 7) {
        NSString *textTemp = textField.text;
        textTemp = [NSString stringWithFormat:@"%@.",textTemp];
        textField.text = textTemp;
    }
    
    if (location == 11) {
        NSString *textTemp = textField.text;
        textTemp = [NSString stringWithFormat:@"%@-",textTemp];
        textField.text = textTemp;
    }
    
    if (textField.text.length >= 14) {
        return NO;
    }
    
    return YES;
}

-(NSString *)textWithoutFormat{
    NSString *textTemp = self.text;
    textTemp = [textTemp stringByReplacingOccurrencesOfString:@"." withString:@""];
    textTemp = [textTemp stringByReplacingOccurrencesOfString:@"-" withString:@""];
    textTemp = [textTemp stringByReplacingOccurrencesOfString:@"(" withString:@""];
    textTemp = [textTemp stringByReplacingOccurrencesOfString:@")" withString:@""];
    return textTemp;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [self formatCpfTextField:textField Range:range String:string];
    
    return YES;
}

-(void)setDelegate:(id<UITextFieldDelegate>)delegate{
    if (![delegate isKindOfClass:[self class]]) {
        return;
    }
    [super setDelegate:delegate];
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self;
        [self setKeyboardType:UIKeyboardTypeNumberPad];
        if (!isiPad()) {
            //adiciona barra encima do teclado com botão de 'ok' para remover o teclado (apenas em iPhones)
            UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenBoundsWidth(), 50)];
            toolbar.barStyle = UIBarStyleBlackTranslucent;
            toolbar.items = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                             [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(doneKeyboard)],
                             nil];
            [toolbar sizeToFit];
            self.inputAccessoryView = toolbar;
        }

    }
    return self;
}

-(void)doneKeyboard{
    //[self resignFirstResponder];
    if ([delegateCpf respondsToSelector:@selector(CPFFieldKeyboarkOkPressed:)]){
        [delegateCpf CPFFieldKeyboarkOkPressed:self];
    }
}

@end
