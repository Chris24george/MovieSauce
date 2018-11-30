//
//  SongViewModel.swift
//  CVVM
//
//  Created by Tibor Bödecs on 2018. 04. 13..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit

class SongViewModel: CollectionViewViewModel<SongCell, Song> {
    
    override func config(cell: SongCell, data: Song, indexPath: IndexPath, grid: Grid) {
        cell.numberLabel.text = "\(indexPath.row + 1)."
        cell.textLabel.text = data.name
        cell.detailTextLabel.text = data.duration
    }
    
    override func size(data: Song, indexPath: IndexPath, grid: Grid, view: UIView) -> CGSize {
        return grid.size(for: view, height: 44, items: grid.columns)
    }
}
