//
//  Testing.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 7.06.2023.
//

/// Testing Related

/*
 
Here are the steps to get started with unit testing in your MVVM app:

 --> Set Up a Test Target: In Xcode, you need to create a separate test target for your unit tests. This target will contain your test classes and dependencies. To create a test target, go to File -> New -> Target and select the appropriate test target template.

 --> Write Unit Tests: In your test target, create test classes and write test methods to verify the behavior of your code. Start by identifying the units or components you want to test. These can include ViewModel methods, utility functions, or any other logic you want to validate. Write test methods that cover different scenarios and expected outcomes for these units.

 --> Use XCTest Framework: XCTest is the testing framework provided by Apple for unit testing in Xcode. Use XCTest assertions (e.g., XCTAssert, XCTAssertEqual, etc.) to define the expected results and compare them with the actual results of your code.

 --> Mock Dependencies: In MVVM architecture, the ViewModel often depends on other components such as data providers or services. To isolate the ViewModel during testing, create mock objects or stubs for these dependencies. Mock objects simulate the behavior of real dependencies and allow you to control the test environment.

 --> Test ViewModel Methods: Write unit tests for your ViewModel methods. Set up the necessary input data, call the ViewModel method under test, and verify that the output is as expected. Use assertions to check if the ViewModel behaves correctly based on different input scenarios.

 --> Test Data Binding: In MVVM, data binding is an important aspect. Test the data binding mechanism by setting up bindings in your test environment and verifying that the data flows correctly between the ViewModel and the View.

 --> Run Tests: Build and run your unit tests by selecting the test target and clicking the Test button in Xcode. The test results will show you which tests pass, fail, or encounter errors.

 --> Repeat for Other Components: Repeat the process for other components in your MVVM architecture, such as the Model or any utility classes you have. Create separate test classes and write tests for each component.

 Remember, unit testing is an ongoing process, and you should aim to cover critical parts of your codebase with tests. It helps ensure the correctness of your implementation, aids in catching bugs early, and facilitates easier maintenance and refactoring.
 
*/

/*
 
 --> Write test to the contracted methods of the view model.
*--> https://github.com/seanhenry/SwiftMockGeneratorForXcode does the boilerplate of Mocking
*--> given-when-then --> is the fashion used for testing
 
 
*/

