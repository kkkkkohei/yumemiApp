//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var results: [[String: Any]]=[]
    var task: URLSessionTask?
    var searchWord: String!
    var url: String!
    var idx: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Viewを読み込んだ後、追加の設定を行う
        searchBar.placeholder = "リポジトリ名を入力"
        searchBar.delegate = self
    }
    
    // 返り値Boolを消した、初期化時の動作追加
    private func searchBarShouldBeginEditing(_ searchBar: UISearchBar){
        // 入力欄初期化
        searchBar.text = ""
        searchBar.placeholder = "入力可能文字は半角英数字のみです"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWord = searchBar.text!
        // 文字入力がなければメソッドを抜ける
        if searchWord.count == 0 {return}
        // 半角英数以外の入力は警告
        if isAlphanumeric(str: searchWord) == false{
            searchBarShouldBeginEditing(searchBar)
            return
        }
        url = "https://api.github.com/search/repositories?q=\(searchWord!)"
        task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let object = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] else {return}
            guard let items = object["items"] as? [[String: Any]] else {return}
            
            self.results = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // リストの更新
        task?.resume()
    }
    
    /// 文字が半角英数字のみか判定します
    /// - Returns: true：半角英数字のみ、false：半角英数字以外が含まれる
    func isAlphanumeric(str: String) -> Bool {
        return str.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let dtl = segue.destination as! ViewController2
            dtl.viewController1 = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = UITableViewCell()
        let resultPath = results[indexPath.row]
        
        cells.textLabel?.text = resultPath["full_name"] as? String ?? ""
        cells.detailTextLabel?.text = resultPath["language"] as? String ?? ""
        cells.tag = indexPath.row
        return cells
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        idx = indexPath.row
        
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
}
