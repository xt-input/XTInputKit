//
//  TableViewController.swift
//  XTInputKitDemo
//
//  Created by xt-input on 2019/5/22.
//  Copyright © 2019 tcoding.cn. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XTINavigationItemDelegate {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.cyan
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
        self.xti_setBarButtonItem(.backLeft)
    }

    func toucheNavigationBarButtonItem(_ position: XTINAVPOSITION) {
        xtiloger.debug(position.rawValue)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

    var height = 65
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.height)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableView.className, for: indexPath)

        xtiloger.debug(indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.height = self.height + 10
        self.tableView.reloadData()
    }
}
