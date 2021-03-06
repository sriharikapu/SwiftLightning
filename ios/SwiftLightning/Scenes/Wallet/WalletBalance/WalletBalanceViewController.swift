//
//  WalletBalanceViewController.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-05-13.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol WalletBalanceDisplayLogic: class {
  func displayRefresh(viewModel: WalletBalance.Refresh.ViewModel)
  func displayError(viewModel: WalletBalance.ErrorVM)
}

class WalletBalanceViewController: SLViewController, WalletBalanceDisplayLogic {
  var interactor: WalletBalanceBusinessLogic?
  var router: (NSObjectProtocol & WalletBalanceRoutingLogic & WalletBalanceDataPassing)?

  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = WalletBalanceInteractor()
    let presenter = WalletBalancePresenter()
    let router = WalletBalanceRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let request = WalletBalance.Refresh.Request()
    interactor?.refresh(request: request)
  }
  
  
  // MARK: Wallet Balance Refresh
  
  @IBOutlet weak var totalBalanceLabelView: SLFormTextLabel!
  @IBOutlet weak var onChainTotalLabel: UILabel!
  @IBOutlet weak var onChainConfirmedLabel: UILabel!
  @IBOutlet weak var onChainUnconfirmedLabel: UILabel!
  @IBOutlet weak var inChannelConfirmedLabel: UILabel!
  @IBOutlet weak var inChannelPendingLabel: UILabel!
  
  
  func displayRefresh(viewModel: WalletBalance.Refresh.ViewModel) {
    DispatchQueue.main.async {
      self.totalBalanceLabelView.textLabel.text = viewModel.totalBalance
      self.onChainTotalLabel.text = viewModel.onChainTotal
      self.onChainConfirmedLabel.text = viewModel.onChainConfirmed
      self.onChainUnconfirmedLabel.text = viewModel.onChainUnconfirmed
      self.inChannelConfirmedLabel.text = viewModel.channelConfirmed
      self.inChannelPendingLabel.text = viewModel.channelPending
    }
  }
  
  
  // MARK: Error Display
  
  func displayError(viewModel: WalletBalance.ErrorVM) {
    let alertDialog = UIAlertController(title: viewModel.errTitle,
                                        message: viewModel.errMsg, preferredStyle: .alert).addAction(title: "OK", style: .default)
    DispatchQueue.main.async {
      self.present(alertDialog, animated: true, completion: nil)
      // self.activityIndicator.remove()
    }
  }
  
  
  // MARK: Dismiss Tapped
  
  @IBAction private func closeCrossTapped(_ sender: UIBarButtonItem) {
    router?.routeToWalletMain()
  }
}
