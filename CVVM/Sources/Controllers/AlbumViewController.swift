//
//  DetailViewController.swift
//  CVVM
//
//  Created by Tibor Bödecs on 2018. 04. 13..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit

class AlbumViewController: CollectionViewController {
    
    var album: Album!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.album.artirst

        let albumSection = CollectionViewSection(items: [AlbumViewModel(self.album)])
        albumSection.header = HeaderViewModel(self.album.name)

        let songs = Array<Song>(repeating: Song(name: "Lorem ipsum dolor sit amet", duration: "04:13"), count: 12)
        let items = songs.map { SongViewModel($0) }
        let newItems: [CollectionViewViewModelProtocol] = Array(items.map { [$0] }
                                                            .joined(separator: [SeparatorViewModel(2)]))

        let songSection = CollectionViewSection(items: newItems)
        songSection.header = HeaderViewModel("Songs")

        let grid = Grid(columns: 1, margin: UIEdgeInsets(all: 8))
        self.source = CollectionViewSource(grid: grid, sections: [albumSection, songSection])
        self.collectionView.reloadData()
    }
    
}
