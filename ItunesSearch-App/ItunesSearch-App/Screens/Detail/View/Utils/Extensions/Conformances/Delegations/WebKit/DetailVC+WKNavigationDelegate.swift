//
//  DetailVC+WKNavigationDelegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 29.05.2023.
//

import WebKit

extension DetailVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spinnerOfWeb.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinnerOfWeb.stopAnimating()
    }
}
