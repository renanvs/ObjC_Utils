//
//  PhoneField.m
//  VET
//
//  Created by renan veloso silva on 9/13/14.
//  Copyright (c) 2014 renanvs. All rights reserved.
//

#import "PhoneField.h"
#import "Utils.h"

@implementation PhoneField
@synthesize delegatePhone;

-(void)willMoveToSuperview:(UIView *)newSuperview{
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

-(void)doneKeyboard{
    if ([delegatePhone respondsToSelector:@selector(PhoneFieldKeyboarkOkPressed:)]){
        [delegatePhone PhoneFieldKeyboarkOkPressed:self];
    }
    //[self resignFirstResponder];
}

#pragma mark - TextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //caso cai nesse IF entende se que esteja apagando o texto logo no começo do campo, evitando apagar o  '('
    if ([string isEqualToString:@""] && [textField.text isEqualToString:@"("]) {
        return NO;
    }
    
    //tosee: dont remember
    if (textField.text.length == 13 && range.location == 3) {
        NSMutableString *stringM = [NSMutableString stringWithString:textField.text];
        [stringM insertString:string atIndex:4];
        [self setTextInside:stringM];
        return NO;
    }
    
    if (textField.text.length > 13) {
        NSRange range1 = [textField.text rangeOfString:@"("];
        NSRange range2 = [textField.text rangeOfString:@")"];
        NSRange range3 = [textField.text rangeOfString:@"-"];
        if (range1.length > 0 && range2.length > 0 && range3.length > 0 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    if (![NSString isStringWithNumeric:string] && ![string isEqualToString:@""]) {
        return NO;
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:textField.text];
    
    if (range.location == 3 && range.length == 0 && textField.text.length < 13) {
        [mutableString appendString:@")"];
        [self setTextInside:mutableString];
    }
    
    if (range.location == 8 && range.length == 0) {
        [mutableString appendString:@"-"];
        [self setTextInside:mutableString];
    }
    
    if (range.location == 13 && range.length == 1) {
        mutableString = [NSMutableString stringWithString:[mutableString stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        [mutableString insertString:@"-" atIndex:8];
        [self setTextInside:mutableString];
        
    }
    
    if (range.location >= 14) {
        return NO;
    }
    
    if (string.length >= 8) {
        [self formatNumToPhone:string];
        return NO;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(lastChanged) userInfo:nil repeats:NO];
    
    return YES;
}

-(void)formatNumToPhone:(NSString*)string{
    if (string.length < 8) {
        return;
    }
    
    NSMutableString *stringM = [NSMutableString stringWithString:string];
    if (stringM.length == 8) {
        [stringM insertString:@"-" atIndex:4];
        [stringM insertString:@"(" atIndex:0];
        [stringM insertString:@")" atIndex:1];
    }
    
    if (stringM.length == 9) {
        [stringM insertString:@"-" atIndex:5];
        [stringM insertString:@"(" atIndex:0];
        [stringM insertString:@")" atIndex:1];
    }
    
    if (stringM.length == 11) {
        [stringM insertString:@"-" atIndex:7];
        [stringM insertString:@"(" atIndex:0];
        [stringM insertString:@")" atIndex:3];
    }
    
    if (stringM.length == 10) {
        [stringM insertString:@"-" atIndex:6];
        [stringM insertString:@"(" atIndex:0];
        [stringM insertString:@")" atIndex:3];
    }
    
    [self setTextInside:stringM];
}

-(void)setTextInside:(NSString*)string{
    inside = YES;
    stringInside = string;
    [self setText:stringInside];
}

-(void)lastChanged{
    if (self.text.length == 14) {
        self.text = [self.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSMutableString *text = [[NSMutableString alloc] initWithString:self.text];
        [text insertString:@"-" atIndex:9];
        self.text = text;
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([delegatePhone respondsToSelector:@selector(PhoneFieldDidBeginEditing:)]) {
        [delegatePhone PhoneFieldDidBeginEditing:self];
    }
    
    if ([NSString isStringEmpty:textField.text]) {
        [self setTextInside: @"("];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@"("]) {
        [self setTextInside: @""];
    }
    
    [self analyzeCurrentString];
}

-(void)analyzeCurrentString{
    NSString *finalString = self.text;
    self.hasError = NO;
    NSString *errorDescription;
    
    if ([NSString isStringEmpty:finalString]) {
        self.hasError = NO;
    }else{
        NSRange range1 = [finalString rangeOfString:@"()"];
        if (range1.length > 0) {
            self.hasError = YES;
            errorDescription = @"Falta DDD. Ex.: (11)";
        }
        
        if (finalString.length < 13) {
            self.hasError = YES;
            errorDescription = @"Falta algum número";
        }
    }
        
    if (self.hasError) {
        self.hasError = YES;
        if ([delegatePhone respondsToSelector:@selector(PhoneFieldError:StringField:)]) {
            [delegatePhone PhoneFieldError:errorDescription StringField:self];
        }
    }
}

-(BOOL)isValidPhone{
    [self analyzeCurrentString];
    return !self.hasError;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}

+(NSString*)textWithoutFormat:(NSString*)string{
    NSString *str = string;
    str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return str;
}

-(void)setDelegate:(id<UITextFieldDelegate>)delegate{
    if (![delegate isKindOfClass:[self class]]) {
        return;
    }
    [super setDelegate:delegate];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    return YES;
}

-(void)setText:(NSString *)text{
    if (!inside) {
        text = [text removeSpecialChars];
        [self formatNumToPhone:text];
        [self analyzeCurrentString];
        if ([text isEqualToString:@""]){
            stringInside = @"";
        }
        [super setText:stringInside];
    }else{
        inside = NO;
        [super setText:text];
    }
}

@end
