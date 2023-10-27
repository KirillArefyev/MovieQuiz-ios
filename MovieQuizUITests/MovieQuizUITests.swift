//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Кирилл on 15.10.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(firstPosterData != secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(firstPosterData != secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertView() {
        sleep(3)
        
        let alert = app.alerts["Alert"]
        var countTaps = 0
        
        repeat {
            app.buttons["Да"].tap()
            countTaps += 1
            sleep(3)
        } while countTaps < 10
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }
    
    func testAlertButtonRestartGame() {
        sleep(3)
        
        let alert = app.alerts["Alert"]
        var countTaps = 0
        
        repeat {
            app.buttons["Нет"].tap()
            countTaps += 1
            sleep(3)
        } while countTaps < 10
        
        alert.buttons.firstMatch.tap()
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
