//
//  Product.h
//  Training
//
//  Created by Daniela Riesgo on 2/3/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

- (instancetype)initWithDetail:(NSString *)detail
                      quantity:(NSNumber *)quantity
                         price:(NSNumber *)price;

@property (strong, nonatomic) NSString * detail;
@property (strong, nonatomic) NSNumber * quantity;
@property (strong, nonatomic) NSNumber * price;

@end
