//
//  UIResponder.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/17.
//

import UIKit

extension UIResponder {
    func getViewController() -> UIViewController? {
        var nextResponder = self
        while let next = nextResponder.next {
            nextResponder = next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
