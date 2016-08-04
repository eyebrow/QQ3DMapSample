//
//  CustomHeatTileOverlay.m
//  Tencent_Map_Demo_Vector
//
//  Created by WangXiaokun on 16/3/14.
//  Copyright © 2016年 WangXiaokun. All rights reserved.
//

#import "CustomHeatTileOverlay.h"

@implementation CustomHeatTileOverlay

-(void)colorForValue:(CGFloat)value
              outRed:(CGFloat *)outRed
            outGreen:(CGFloat *)outGreen
             outBlue:(CGFloat *)outBlue
            outAlpha:(CGFloat *)outAlpha {
    *outRed = 1;
    *outGreen = 0.46;
    *outBlue = 0.01;
    value = value > 1 ? 1 : sqrt(value);
    value = sqrt(value);
    if (value > 0.7) {
        *outGreen = 0.3;
        *outBlue = 0.003;
    }
    if (value > 0.6) {
        *outAlpha = 78 * pow(value - 0.7, 3) + 0.9;
    } else if (value > 0.4) {
        *outAlpha = 78 * pow(value - 0.5, 3) + 0.7;
    } else if (value > 0.2) {
        *outAlpha = 78 * pow(value - 0.3, 3) + 0.6;
    } else {
        *outAlpha = value * 2;
    }
    if (*outAlpha > 1) {
        *outAlpha = 1;
    }
}
@end