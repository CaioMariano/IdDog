//
//  Alert.swift
//  IdDog
//
//  Created by Caio Araujo Mariano on 24/11/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import Foundation
import UIKit

extension DodFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dogCellSize = (dogsCollectionView.frame.width/3) - 10
        return CGSize(width: dogCellSize, height: dogCellSize)
    }
}


