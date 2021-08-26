//
//  FeedView.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import UIKit
import RxCocoa
import RxSwift




class FeedView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var coordinator: MainAppCoordinator!
    private var viewModel: FeedViewModel!
    private var disposeBag: DisposeBag!
}

extension FeedView: StoryboardInstantiatable {
    
    public struct Dependency {
        let coordinator: MainAppCoordinator
        let viewModel: FeedViewModel
        let disposeBag: DisposeBag
    }
    
    static var storyboardName: StoryboardName { "Main" }
    
    func inject(_ dependency: Dependency) {
        _ = self.view
        
        self.title = "Feed"
        self.coordinator = dependency.coordinator
        self.viewModel = dependency.viewModel
        self.disposeBag = dependency.disposeBag
        
        tableView.refreshControl = UIRefreshControl()
        tableView.tableFooterView = UIView()
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.Identifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
  
        
        
        
        let input = FeedViewModel.Input(onItemSelected: self.tableView.rx.itemSelected, onReachedBottom: tableView.rx.reachedBottom())
        let output = self.viewModel.transform(input: input)
        
        output.isLoading.drive(self.showLoadingIndicator).disposed(by: disposeBag)
        output.showTableviewPlaceholder.drive(showTableviewPlaceholder).disposed(by: disposeBag)
        output.presentDetailedView.drive(self.coordinator.rx.navigateToDetailScreen).disposed(by: disposeBag)
        output.rows.drive(tableView.rx.items(cellIdentifier: SubtitleTableViewCell.Identifier, cellType: SubtitleTableViewCell.self)) { (row, data, cell ) in
            cell.configure(data, completion: { [weak self] in self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)})
        }
        .disposed(by: disposeBag)
        
    }
}

extension FeedView {
    
    var showLoadingIndicator: Binder<Bool> {
        return Binder(self.tableView) { (table, show) in
            table.tableFooterView = show ? LoadingView() : UIView(frame: .zero)
        }
    }
    
    var showTableviewPlaceholder: Binder<Bool> {
        return Binder(self.tableView, binding: { (table, show) in
            table.backgroundView = show ? PlaceholderTextView(textPlaceholder: "Looks like there is no data or something bad happend.") : nil
        })
    }
}

extension FeedView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
