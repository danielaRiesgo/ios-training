//
//  Product.m
//  Training
//
//  Created by Daniela Riesgo on 2/3/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

#import "Product.h"

@implementation Product

- (instancetype)initWithDetail:(NSString *)detail
                      quantity:(NSNumber *)quantity
                         price:(NSNumber *)price {
    self = [super init];
    if (self) {
        self.detail = detail;
        self.quantity = quantity;
        self.price = price;
    }
    return self;
}


@end
