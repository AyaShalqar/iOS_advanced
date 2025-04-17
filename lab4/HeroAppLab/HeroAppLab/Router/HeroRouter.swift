//
//  HeroRouter.swift
//  HeroAppLab
//
//  Created by Aknur Seidazym on 17.03.2025.
//

import SwiftUI
import UIKit

final class HeroRouter {
    var rootViewController: UINavigationController?

    func showDetails(for id: Int) {
        let detailVC = makeDetailViewController(id: id)
        rootViewController?.pushViewController(detailVC, animated: true)
    }

    private func makeDetailViewController(id: Int) -> UIViewController {
//        let mockVC = UIViewController()
//        mockVC.view.backgroundColor = .white
//            
//        
//        return mockVC
        let service = HeroServiceImpl()
        let viewModel = HeroDetailViewModel(service: service, heroId: id)
        let detailView = HeroDetailView(viewModel: viewModel)
       
        let hostingController = UIHostingController(rootView: detailView)
        return hostingController
    }
}
