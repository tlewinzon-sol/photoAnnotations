//
//  ResizableView.swift
//  PhotoAnnotations
//
//  Created by Tobias Lewinzon on 26/07/2020.
//  Copyright © 2020 tobiaslewinzon. All rights reserved.
//

import UIKit


// From: https://stackoverflow.com/questions/8460119/how-to-resize-uiview-by-dragging-from-its-edges
class ResizableView: UIView {

    enum Edge {
        case topLeft, topRight, bottomLeft, bottomRight, none
    }

    var edgeSize: CGFloat = 44.0

    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    
    // Get which edge is the user trying to drag.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {

            touchStart = touch.location(in: self)

            currentEdge = {
                if self.bounds.size.width - touchStart.x < self.edgeSize && self.bounds.size.height - touchStart.y < self.edgeSize {
                    return .bottomRight
                } else if touchStart.x < self.edgeSize && touchStart.y < self.edgeSize {
                    return .topLeft
                } else if self.bounds.size.width-touchStart.x < self.edgeSize && touchStart.y < self.edgeSize {
                    return .topRight
                } else if touchStart.x < self.edgeSize && self.bounds.size.height - touchStart.y < self.edgeSize {
                    return .bottomLeft
                }
                return .none
            }()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)

            let originX = self.frame.origin.x
            let originY = self.frame.origin.y
            let width = self.frame.size.width
            let height = self.frame.size.height

            let deltaWidth = currentPoint.x - previous.x
            let deltaHeight = currentPoint.y - previous.y

            switch currentEdge {
            case .topLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY + deltaHeight, width: width - deltaWidth, height: height - deltaHeight)
            case .topRight:
                self.frame = CGRect(x: originX, y: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
            case .bottomRight:
                self.frame = CGRect(x: originX, y: originY, width: width + deltaWidth, height: height + deltaHeight)
            case .bottomLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY, width: width - deltaWidth, height: height + deltaHeight)
            default:
                // No edge selected, moving view.
                self.center = CGPoint(x: self.center.x + currentPoint.x - touchStart.x,
                                      y: self.center.y + currentPoint.y - touchStart.y)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentEdge = .none
    }
}
