//
//  DynamicTextViewModel.swift
//  CVVM
//
//  Created by Tibor Bödecs on 2018. 04. 13..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit

public extension UILabel {
    
    public class func height(forWidth width: CGFloat, font: UIFont, text: String) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let label = UILabel(frame: CGRect(origin: .zero, size: size))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}

class DynamicTextViewModel: CollectionViewViewModel<TextCell, String> {
    
    override func config(cell: TextCell, data: String, indexPath: IndexPath, grid: Grid) {
        cell.textLabel.text = data
    }
    
    override func size(data: String, indexPath: IndexPath, grid: Grid, view: UIView) -> CGSize {
        // note: cell has 8pt paddings on every side, that's why the +-16...
        let width = grid.width(for: view) - 16
        let font = UIFont.systemFont(ofSize: 12, weight: .bold)
        let height = UILabel.height(forWidth: width - 16, font: font, text: data)
        return CGSize(width: width, height: height + 16)
    }
}
