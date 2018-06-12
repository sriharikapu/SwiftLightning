//
//  AutopilotRouter.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-06-10.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol AutopilotRoutingLogic {
  func routeToWalletMain()
}

protocol AutopilotDataPassing {
  var dataStore: AutopilotDataStore? { get }
}

class AutopilotRouter: NSObject, AutopilotRoutingLogic, AutopilotDataPassing {
  weak var viewController: AutopilotViewController?
  var dataStore: AutopilotDataStore?
  
  // MARK: Routing
  
  func routeToWalletMain() {
    //    let destinatoinVC = viewController! as! WalletMainViewController
    //    let destinatoinDS = destinationVC.router!.dataStore!
    //    passDataToWalletMain(source: dataStore!, destination: &destinationDS)
    navigateToWalletMain(source: viewController!)
  }

  // MARK: Navigation
  
  func navigateToWalletMain(source: AutopilotViewController) {
    guard let navigationController = source.navigationController else {
      SLLog.assert("\(type(of: source)).navigationController = nil")
      return
    }
    navigationController.popViewController(animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToWalletMain(source: AutopilotDataStore, destination: inout WalletMainDataStore) { }
}
