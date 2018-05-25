//
//  TXFlowLayout.m
//  TailorX
//
//  Created by Qian Shen on 31/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXFlowLayout.h"

@implementation TXFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.minimumInteritemSpacing = 0;
    
    self.minimumLineSpacing = 0;
    
    if (self.collectionView.bounds.size.height) {
        
        self.itemSize = self.collectionView.bounds.size;
    }
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
