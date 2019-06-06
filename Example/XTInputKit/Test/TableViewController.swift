//
//  TableViewController.swift
//  XTInputKitDemo
//
//  Created by xt-input on 2019/5/22.
//  Copyright © 2019 tcoding.cn. All rights reserved.
//

import UIKit
import XTInputKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.className)
        self.view.addSubview(self.tableView)

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
