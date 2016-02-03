//
//  Note.m
//  Training
//
//  Created by Daniela Riesgo on 2/3/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

#import "Note.h"

@implementation Note

- (instancetype)initWithTitle:(NSString *)title
                      detail:(NSString *)detail {
    self = [super init];
    if (self) {
        self.title = title;
        self.detail = detail;
    }
    return self;
}

@end
