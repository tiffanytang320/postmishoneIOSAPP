//
//  PostMishoneUITests.swift
//  PostMishoneUITests
//
//  Created by Victor Liang on 2018-11-17.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import XCTest

class PostMishoneUITests: XCTestCase {
    var app: XCUIApplication!


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }
    
    func testAValidLoginSuccess() {
        app.launch()

        let validEmail = "a@b.com"
        let validPassword = "123456"
//        XCTAssertTrue(app.otherElements["MainViewController"].exists)

        
        app.buttons["Log In"].tap()
        
        XCTAssertTrue(app.otherElements["LoginViewController"].exists)
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(validEmail)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(validPassword)
        
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.exists)
        app.buttons["Continue"].tap()
//        XCTAssertTrue(app.otherElements["MainAppScreen"].exists)
    }
    
    
    func testBPostMissionSuccess() {
        app.launch()
        let missionName = "Test mission name"
        let missionDescription = "Test description name"
        let reward = "$1337"

        
        app.maps.element.press(forDuration: 1.0)
        
        let missionNameTextField = app.textFields["Mission Name"]
        missionNameTextField.tap()
        missionNameTextField.typeText(missionName)
        
        let missionNDescriptionField = app.textFields["Mission Description"]
        missionNDescriptionField.tap()
        missionNDescriptionField.typeText(missionDescription)

        let rewardTextField = app.textFields["Reward"]
        rewardTextField.tap()
        rewardTextField.typeText(reward)
        
        app.buttons["Post Mission"].tap()
    }
    
    
    
    func testCValidLogOutSuccess() {
        app.launch()

        XCTAssertTrue(app.otherElements["MainAppScreen"].exists)
        app/*@START_MENU_TOKEN@*/.tabBars/*[[".otherElements[\"MainViewController\"].tabBars",".tabBars"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .button).element(boundBy: 2).tap()
        app/*@START_MENU_TOKEN@*/.buttons["Log Out"]/*[[".otherElements[\"MainViewController\"]",".otherElements[\"SettingsViewController\"].buttons[\"Log Out\"]",".buttons[\"Log Out\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
//        XCTAssertTrue(app.otherElements["MainViewController"].exists)

        
        
    }
    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        if CommandLine.arguments.contains("--uitesting") {
            let defaultsName = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: defaultsName)
        }
        
        // ...Finish setting up your app
        
        return true
    }

}
