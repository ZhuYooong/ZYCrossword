//
//  ZYWebViewController.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/16.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class ZYWebViewController: UIViewController {
    var httpURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        initItem()
        initData()
    }
    //MARK: - 初始化界面
    func initItem() {
        view.backgroundColor = UIColor.white
        view.addSubview(UIView())
        
        addWebView()
        initProgressView()
    }
    var httpWebView = WKWebView()
    func addWebView() {
        httpWebView = WKWebView()
        httpWebView.allowsBackForwardNavigationGestures = true
        httpWebView.sizeToFit()
        httpWebView.navigationDelegate = self
        httpWebView.uiDelegate = self
        view.addSubview(httpWebView)
        httpWebView.snp.makeConstraints { (make) in
            make.left.right.width.bottom.equalTo(view)
            make.top.equalTo(view).offset(0)
        }
    }
    var progressView: UIProgressView? = nil
    let keyPathForProgress : String = "estimatedProgress"
    func initProgressView() {
        progressView = UIProgressView()
        progressView!.tintColor = navigationController?.navigationBar.barTintColor
        httpWebView.addSubview(progressView!)
        progressView?.snp.makeConstraints({ (make) in
            make.top.left.right.width.equalTo(httpWebView)
            make.height.equalTo(2)
        })
        httpWebView.addObserver(self, forKeyPath: keyPathForProgress, options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old], context: nil)
    }
    //MARK: - 加载数据
    func initData() {
        var request: URLRequest?
        if let urlStr = httpURL?.replacingOccurrences(of: " ", with: "").addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: urlStr) {
                request = URLRequest(url: url)
            }else if let url = URL(string: "http://\(urlStr)") {
                request = URLRequest(url: url)
            }
            httpWebView.load(request!)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            
        }else if keyPath == "title" {
            title = httpWebView.title
        }else if keyPath == "URL" {
            
        }else if keyPath == keyPathForProgress {
            if object as? WKWebView == httpWebView  {
                let progress = self.httpWebView.estimatedProgress
                if progress == 1 {
                    progressView?.isHidden = true
                    progressView?.setProgress(0, animated: false)
                }else {
                    progressView?.isHidden = false
                    progressView?.setProgress(Float(progress), animated: true)
                }
            }else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
    }
    deinit {
        httpWebView.removeObserver(self, forKeyPath: keyPathForProgress)
        httpWebView.navigationDelegate = nil
        httpWebView.uiDelegate = nil
    }
}
extension ZYWebViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) -> Void in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler(alert.textFields![0].text!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
