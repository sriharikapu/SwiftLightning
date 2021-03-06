//
//  PayMainPresenter.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-28.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PayMainPresentationLogic
{
  func presentCheckURL(response: PayMain.CheckURL.Response)
  func presentValidate(response: PayMain.Response)
  func presentConfirmPayment(response: PayMain.Response)
}

class PayMainPresenter: PayMainPresentationLogic
{
  weak var viewController: PayMainDisplayLogic?
  
  
  // MARK: Check Incoming URL
  
  func presentCheckURL(response: PayMain.CheckURL.Response) {
    if let url = response.url {
      viewController?.displayIncomingURL(urlString: url.absoluteString)
    }
  }
  
  
  // MARK: Validate Address & Amount
  
  func presentValidate(response: PayMain.Response) {
    _ = commonUpdate(validationResult: response.validationResult,
                     inputAddress: response.inputAddress,
                     inputAmount: response.inputAmount)
    
    if let error = response.validationResult.error {
      let errorVM = PayMain.ErrorVM(errTitle: "Payment Error", errMsg: error.localizedDescription)
      viewController?.displayError(viewModel: errorVM)
    }
  }
  
  
  // MARK: Confirm Payment
  
  func presentConfirmPayment(response: PayMain.Response) {
    
    let valid = commonUpdate(validationResult: response.validationResult,
                             inputAddress: response.inputAddress,
                             inputAmount: response.inputAmount)
    
    if let error = response.validationResult.error {
      let errorVM = PayMain.ErrorVM(errTitle: "Payment Error", errMsg: error.localizedDescription)
      viewController?.displayError(viewModel: errorVM)
    } else if !valid {
      let errorVM = PayMain.ErrorVM(errTitle: "Payment Error",
                                    errMsg: "One or more Payment details is invalid. Please correct and try again")
      viewController?.displayError(viewModel: errorVM)
    }
    
    if valid {
      viewController?.displayConfirmPayment()
    }
  }
  
  
  // MARK: Common Update
  
  private func commonUpdate(validationResult: PayMain.ValidationResult,
                            inputAddress: String,
                            inputAmount: Bitcoin?) -> Bool {

    var addrInvalid: Bool = false
    var amtInvalid: Bool = false
    var routingInvalid: Bool = false
    
    let amountToShow = inputAmount ?? validationResult.revisedAmount
    let amountExpected = validationResult.revisedAmount
    var paymentType: BitcoinPaymentType? = validationResult.paymentType
    
    let addressError = validationResult.addressError
    let addrErrVM = PayMain.AddressVM(errMsg: addressError?.localizedDescription ?? "")
    viewController?.displayAddressWarning(viewModel: addrErrVM)
    
    if addressError != nil {
      addrInvalid = true
      paymentType = nil
    }
    
    if let error = validationResult.amountError {
      if let amountExpected = amountExpected, error == .amtMismatch {
        let amtErrVM = PayMain.AmountVM(errMsg: "PayReq expects \(amountExpected.formattedInSatoshis())")
        viewController?.displayAmountWarning(viewModel: amtErrVM)
      } else {
        let amtErrVM = PayMain.AmountVM(errMsg: error.localizedDescription)
        viewController?.displayAmountWarning(viewModel: amtErrVM)
      }
      amtInvalid = true
    } else {
      let amtErrVM = PayMain.AmountVM(errMsg: "")
      viewController?.displayAmountWarning(viewModel: amtErrVM)
    }
    
    let routeError = validationResult.routeError
    let routeErrVM = PayMain.WarningVM(errMsg: routeError?.localizedDescription ?? "")
    viewController?.displayWarning(viewModel: routeErrVM)
    routingInvalid = routeError != nil
    
    var addressToShow = validationResult.revisedAddress ?? inputAddress
    if validationResult.paymentType == .lightning {
      addressToShow = inputAddress
    }
    
    let feeString = "\(validationResult.fee?.formattedInSatoshis() ?? "-")"
    
    var balanceString = "balance: -"
    if let balance = validationResult.balance, let paymentType = validationResult.paymentType {
      switch paymentType {
      case .lightning:
        balanceString = "lightning confirmed balance: \(balance.formattedInSatoshis())"
      case .onChain:
        balanceString = "on-chain confirmed balance: \(balance.formattedInSatoshis())"
      }
    }
    
    let viewModel = PayMain.UpdateVM(revisedAddress: addressToShow,
                                     revisedAmount: amountToShow?.formattedInSatoshis(),
                                     payDescription: validationResult.payDescription,
                                     paymentType: paymentType,
                                     fee: "fee: \(feeString)",
                                     balance: balanceString)
    
    viewController?.displayUpdate(viewModel: viewModel)
    viewController?.updateInvalidity(addr: addrInvalid, amt: amtInvalid, route: routingInvalid)
    
    return !(addrInvalid || amtInvalid || routingInvalid)
  }
}
