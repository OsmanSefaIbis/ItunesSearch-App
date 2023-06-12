//
//  MockDetailVC.swift
//  ItunesSearch-AppTests
//
//  Created by Sefa İbiş on 12.06.2023.
//

@testable import ItunesSearch_App
import UIKit

final class MockDetailVC: DetailVCContract {
    
    var viewModel: ItunesSearch_App.DetailVM?
    
    func loadViewIfNeeded() {
        
    }
    
    func configureView(with item: ItunesSearch_App.Detail, _ pair: ItunesSearch_App.ImageColorPair, completion: (() -> Void)?) {
        
    }
    
    func configureMutualFields(_ item: ItunesSearch_App.Detail, _ pair: ItunesSearch_App.ImageColorPair) {
        
    }
    
    func configureMovie(_ item: ItunesSearch_App.Detail) {
        
    }
    
    func configureMusic(_ item: ItunesSearch_App.Detail) {
        
    }
    
    func configureEbook(_ item: ItunesSearch_App.Detail) {
        
    }
    
    func configurePodcast(_ item: ItunesSearch_App.Detail) {
        
    }
    
    func configureBackgroundColors(_ averageColor: UIColor) {
        
    }
    
    func isColorDark(_ color: UIColor) -> Bool {
        return false
    }
    
    func adaptComponentsForDark(_ tintColor: UIColor) {
        
    }
    
    func setTextColorOfView(_ color: UIColor) {
        
    }
    
    func setNavigationBarWith(tintColor color: String) {
        
    }
    
    func convertDate(for dateValue: String) -> String {
        return ""
    }
    
    func capitalizeUppercaseWords(input: String) -> String {
        return ""
    }
    
    func readableFormatTimeFromMillis(millis: Int) -> String {
        return ""
    }
    
    func readableFormatTimeFromSeconds(seconds: Int) -> String {
        return ""
    }
    
    func convertBytesToGBorMB(_ bytes: Int) -> String {
        return ""
    }
    
    func toggleAudioOff() {
        
    }
    
    func toggleAudioOn(_ url: URL) {
        
    }
    
    func addPlayIndicator() {
        
    }
    
    func removeAudioRelated() {
        
    }

}
