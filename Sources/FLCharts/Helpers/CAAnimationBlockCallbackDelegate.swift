//
//  CAAnimationBlockCallbackDelegate.swift
//  FLCharts
//
//  Created by Francesco Leoni on 25/02/22.
//

import UIKit

public typealias CAAnimationBlockCallback = (CAAnimation, Bool) -> ()

public class CAAnimationBlockCallbackDelegate: NSObject, CAAnimationDelegate {
    
   var onStartCallback: CAAnimationBlockCallback?
   var onCompleteCallback: CAAnimationBlockCallback?

   public func animationDidStart(_ anim: CAAnimation) {
      if let startHandler = onStartCallback {
         startHandler(anim, true)
      }
   }

   public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
      if let completionHandler = onCompleteCallback {
         completionHandler(anim, flag);
      }
   }
}

public extension CAAnimation {
    
   // See if there is already a CAAnimationDelegate handling this animation
   // If there is, add onStart to it, if not create one
   func startBlock(callback: @escaping CAAnimationBlockCallback) {
      if let myDelegate = self.delegate as? CAAnimationBlockCallbackDelegate {
         myDelegate.onStartCallback = callback
      } else {
         let callbackDelegate = CAAnimationBlockCallbackDelegate()
         callbackDelegate.onStartCallback = callback
         self.delegate = callbackDelegate
      }
   }

   // See if there is already a CAAnimationDelegate handling this animation
   // If there is, add onCompletion to it, if not create one
   func completionBlock(callback: @escaping CAAnimationBlockCallback) {
      if let myDelegate = self.delegate as? CAAnimationBlockCallbackDelegate {
         myDelegate.onCompleteCallback = callback
      } else {
         let callbackDelegate = CAAnimationBlockCallbackDelegate()
         callbackDelegate.onCompleteCallback = callback
         self.delegate = callbackDelegate
      }
   }
}
