//
//  Note.h
//  Training
//
//  Created by Daniela Riesgo on 2/3/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

- (instancetype)initWithTitle:(NSString *)title
                       detail:(NSString *)detail;

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* detail;

@end
