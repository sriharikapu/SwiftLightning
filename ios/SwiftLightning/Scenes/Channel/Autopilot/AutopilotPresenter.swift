//
//  AutopilotPresenter.swift
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

protocol AutopilotPresentationLogic {
  func presentReadConfig(response: Autopilot.ReadConfig.Response)
  func presentWriteConfig(response: Autopilot.WriteConfig.Response)
}

class AutopilotPresenter: AutopilotPresentationLogic {
  weak var viewController: AutopilotDisplayLogic?
  
  func presentReadConfig(response: Autopilot.ReadConfig.Response) {
    
    switch response.result {
    case .success(let config):
      let viewModel = Autopilot.ReadConfig.ViewModel(active: config.active,
                                                     fundAlloc: config.fundAllocation,
                                                     minChanSize: Bitcoin(inSatoshi: config.minChannelValue),
                                                     maxChanSize: Bitcoin(inSatoshi: config.maxChannelValue),
                                                     maxChanNum: config.maxNumChannels)
      viewController?.displayConfig(viewModel: viewModel)
      
    case .failure(let error):
      let errorVM = Autopilot.ErrorVM(errTitle: "Cannot Read Config",
                                      errMsg: error.localizedDescription)
      viewController?.displayError(viewModel: errorVM)
    }
  }
  
  func presentWriteConfig(response: Autopilot.WriteConfig.Response) {
  }
}
