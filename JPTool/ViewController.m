//
//  ViewController.m
//  JPTool
//
//  Created by SunYang on 2017/10/31.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "ViewController.h"
#import "TGClassObject.h"

@interface ViewController()

@property (unsafe_unretained) IBOutlet NSTextView *inputTextView;
@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
@property (weak) IBOutlet NSTextField *superClassTF;
@property (weak) IBOutlet NSTextField *modelNameTF;



@end

@implementation ViewController



- (IBAction)convertButtonClick:(id)sender {
    
    NSString *JSONString = [[self.inputTextView.string stringByReplacingOccurrencesOfString:@"”" withString:@"\""] stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    
    if (JSONString.length == 0) {
        self.outputTextView.string = @"No Data......";
        return;
    }
    
    NSError *error;
    
    NSDictionary *JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        self.outputTextView.string = error.localizedDescription;
        return;
    }
    
    NSMutableArray *classes = [NSMutableArray array];
    NSString *superClass = self.superClassTF.stringValue.length > 0 ? self.superClassTF.stringValue : @"NSObject";
    
    TGClassObject *rootObject = [TGClassObject new];
    [classes addObject:rootObject];
    rootObject.className = self.modelNameTF.stringValue.length > 0 ? self.modelNameTF.stringValue : @"ModelBase";
    rootObject.properties = [TGClassObject handleDictionary:JSONObject container:classes];
    
    NSMutableString *fin = [NSMutableString string];
    for (TGClassObject *classObject in classes) {
        [fin appendFormat:@"\n"];
        NSString *classString = [NSString stringWithFormat:@"@interface %@: %@\n\n", classObject.className, superClass];
        [fin appendString:classString];
        for (NSString *property in classObject.properties) {
            [fin appendFormat:@"%@\n", property];
        }
        [fin appendString:@"\n@end\n"];
    }
    self.outputTextView.string = [fin copy];
}

@end















