//
//  Extensions.swift
//  PhotoAnnotations
//
//  Created by Tobias Lewinzon on 12/08/2020.
//  Copyright © 2020 tobiaslewinzon. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Generates image with passed view drawn as a snapshot.
    convenience init(view: UIView) {
        // Create image context from desired view's frame (size and position)
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        
        // Call drawHierarchy on view. This method renders the view content into the current image context.
        // afterScreenUpdates waits for the IU changes to be rendered before drawing.
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image?.cgImage {
            self.init(cgImage: image)
        } else {
            self.init()
        }
    }
}

