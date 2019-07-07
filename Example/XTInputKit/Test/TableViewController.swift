//
//  TableViewController.swift
//  XTInputKitDemo
//
//  Created by xt-input on 2019/5/22.
//  Copyright © 2019 tcoding.cn. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
//        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.backgroundColor = UIColor.xti.random
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.className)
//        self.view.addSubview(self.tableView)
//        self.tableView.snp.makeConstraints { make in
//            make.edges.equalTo(UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0))
//        }

        self.xti_setBarButtonItem(.right)
    }

    @objc func xti_toucheRightBarButtonItem() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        xtiloger.debug("numberOfSections")
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        xtiloger.debug(section)
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)

        xtiloger.debug(indexPath)

        return cell
    }
}
