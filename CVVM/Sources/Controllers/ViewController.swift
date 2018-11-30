//
//  ViewController.swift
//  CVVM
//
//  Created by Tibor Bödecs on 2018. 04. 12..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit

class ViewController: CollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CVVM"
    
        let albums = [
            Album(artirst: "August Burns Red", name: "Constellations", image: "01"),
            Album(artirst: "Breakdown of Sanity", name: "Mirrors", image: "02"),
            Album(artirst: "Currents", name: "The place I feel safest", image: "03"),
            Album(artirst: "Make Them Suffer", name: "Neverbloom", image: "04"),
            Album(artirst: "Parkway Drive", name: "Reverence", image: "05"),
            Album(artirst: "The Haunted", name: "Exit wounds", image: "06"),
            Album(artirst: "Upon a Burning Body", name: "Red White Green", image: "07"),
            Album(artirst: "Whitechapel", name: "Our endless war", image: "08"),
        ]
        
        let grid = Grid(columns: 4, margin: UIEdgeInsets(all: 8))
        
        let artistSection = CollectionViewSection(items: [self.createHorizontal()])
        artistSection.header = HeaderViewModel("Top metal artists")
        
        let items = albums.map { album -> AlbumViewModel in
            let viewModel = AlbumViewModel(album)
            viewModel.delegate = self
            return viewModel
        }
        let albumSection = CollectionViewSection(items: items)
        albumSection.header = HeaderViewModel("Top metal albums")
        
        self.source  = CollectionViewSource(grid: grid, sections: [artistSection, albumSection])
        self.collectionView.reloadData()
    }
    
    func createHorizontal() -> CollectionViewModel {
        let artists = [
            Artist(name: "August Burns Red", image: "a01"),
            Artist(name: "Breakdown of Sanity", image: "a02"),
            Artist(name: "Currents", image: "a03"),
            Artist(name: "Make Them Suffer", image: "a04"),
            Artist(name: "Parkway Drive", image: "a05"),
            Artist(name: "The Haunted", image: "a06"),
            Artist(name: "Upon a Burning Body", image: "a07"),
            Artist(name: "Whitechapel", image: "a08"),
        ]

        let items = artists.map { artist -> HorizontalArtistViewModel in
            let viewModel = HorizontalArtistViewModel(artist)
            viewModel.delegate = self
            return viewModel
        }

        let grid = Grid(columns: 4, margin: UIEdgeInsets(all: 8))
        let section = CollectionViewSection(items: items)
        let source  = CollectionViewSource(grid: grid, sections: [section])
        
        return CollectionViewModel(source)
    }
}

extension ViewController: ArtistViewModelDelegate {
    
    func didSelect(artist: Artist) {
        let viewController = ArtistViewController(nibName: nil, bundle: nil)
        viewController.artist = artist
        self.show(viewController, sender: nil)
    }
}


extension ViewController: AlbumViewModelDelegate {

    func didSelect(album: Album) {
        let viewController = AlbumViewController(nibName: nil, bundle: nil)
        viewController.album = album
        self.show(viewController, sender: nil)
    }
}
