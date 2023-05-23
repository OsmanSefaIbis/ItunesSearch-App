//
//  DetailView+Interface.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 10.05.2023.
//

import UIKit
// laterTODO: order properly, order class
// laterTODO: Analyze this interface properly to make it as neat as possible
protocol DetailViewContract: AnyObject {
    
    var viewModel: DetailViewModel? { get set }
    ///configure
    func configureView(with item: Detail, _ pair: ImageColorPair, completion: (() -> Void)?)
    func configureMutualFields(_ item: Detail, _ pair: ImageColorPair)
    ///configure specific
    func configureMovie(_ item: Detail)
    func configureMusic(_ item: Detail)
    func configureEbook(_ item: Detail)
    func configurePodcast(_ item: Detail)
    ///configure UI
    func configureBackgroundColors(_ averageColor: UIColor)
    func isColorDark(_ color: UIColor) -> Bool /// handles UX case
    func adaptComponentsForDark(_ tintColor: UIColor)
    func setTextColorOfView(_ color: UIColor)
    func setNavigationBarWith( tintColor color: String)
    ///data manipulation
    func convertDate(for dateValue: String) -> String
    func capitalizeUppercaseWords(input: String) -> String
    func readableFormatTimeFromMillis(millis: Int) -> String
    func readableFormatTimeFromSeconds(seconds: Int) -> String
    func convertBytesToGBorMB(_ bytes: Int) -> String
    ///operations
    func toggleAudioOff()
    func toggleAudioOn(_ url: URL)
    func addPlayIndicator()
    func removeAudioRelated()
}
