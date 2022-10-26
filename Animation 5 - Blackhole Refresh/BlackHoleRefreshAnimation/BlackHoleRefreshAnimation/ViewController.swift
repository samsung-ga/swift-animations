//
//  ViewController.swift
//  BlackHoleRefreshAnimation
//
//  Created by Jaeyong Lee on 2022/10/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BlackholeDelegate {

    @IBOutlet weak var tableView: UITableView!

    var items: [String] = ["유령", "사탕", "괴물", "귀신", "생일", "파티", "장난", "속임수", "할리우드", "유령",
                           "사탕", "괴물", "귀신", "생일", "파티", "장난", "속임수", "할리우드", "유령", "사탕",
                           "괴물", "귀신", "생일", "파티", "장난", "속임수", "할리우드"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAppearance()
        let blackholeViewFrame = CGRect(
            origin: .init(x: 0, y: view.safeAreaInsets.top),
            size: .init(width: tableView.frame.width, height: tableView.frame.width * 3 / 4.5)
        )
        tableView.backgroundColor = .clear
        let blackholeView = BlackholeView(frame: blackholeViewFrame, scrollView: tableView)
        blackholeView.delegate = self
        view.addSubview(blackholeView)
        view.sendSubviewToBack(blackholeView)
        view.backgroundColor = UIColor(named: "space")
    }

    func blackholeViewDidRefresh(_ blackholeView: BlackholeView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            blackholeView.endLoading()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = items[indexPath.row]
        configuration.textProperties.color = .white
        cell.backgroundColor = UIColor(named: "space")
        cell.contentConfiguration = configuration
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ViewController {

    private func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear 
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance  = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
