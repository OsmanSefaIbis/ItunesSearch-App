//
//  DetailView+Interface.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 10.05.2023.
//

import UIKit

protocol DetailVCContract: AnyObject {
    /// props
    var viewModel: DetailVM? { get set }
    /// view life-cycle
    func loadViewIfNeeded()
    /// assemble detail page
    func configureView(with item: Detail, _ pair: ImageColorPair, completion: (() -> Void)?)
    func configureMutualFields(_ item: Detail, _ pair: ImageColorPair)
    /// configure accordinly by media
    func configureMovie(_ item: Detail)
    func configureMusic(_ item: Detail)
    func configureEbook(_ item: Detail)
    func configurePodcast(_ item: Detail)
    /// configure UI specific
    func configureBackgroundColors(_ averageColor: UIColor)
    func isColorDark(_ color: UIColor) -> Bool
    func adaptComponentsForDark(_ tintColor: UIColor)
    func setTextColorOfView(_ color: UIColor)
    func setNavigationBarWith( tintColor color: String)
    /// data formatting
    func convertDate(for dateValue: String) -> String
    func capitalizeUppercaseWords(input: String) -> String
    func readableFormatTimeFromMillis(millis: Int) -> String
    func readableFormatTimeFromSeconds(seconds: Int) -> String
    func convertBytesToGBorMB(_ bytes: Int) -> String
    /// operations
    func toggleAudioOff()
    func toggleAudioOn(_ url: URL)
    func addPlayIndicator()
    func removeAudioRelated()
}
