//
//  StockTableViewCellTests.swift
//  StockListTests
//
//  Created by Piyush Pandey on 21/11/24.
//

import XCTest
@testable import StockList

final class StockTableViewCellTests: XCTestCase {
    var cell: StockTableViewCell!
    
    override func setUp() {
        super.setUp()
        cell = StockTableViewCell(style: .default, reuseIdentifier: StockTableViewCell.identifier)
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    func testCellIdentifier() {
        XCTAssertEqual(StockTableViewCell.identifier, "StockTableViewCell",
                       "Cell identifier should match class name")
    }
    
    func testInitialization() {
        XCTAssertNotNil(cell, "Cell should be initialized")
        
        // Check if subviews are added to contentView
        XCTAssertTrue(cell.contentView.subviews.contains(cell.containerView),
                      "ContainerView should be added to contentView")
    }
    
    func testCellConfiguration() {
        // Create a mock Stock object
        let mockStock = Stock(
            symbol: "AAPL",
            quantity: 10,
            ltp: 150.50, 
            avgPrice: 120.0,
            close: 148.75
        )
        
        cell.configure(with: mockStock)
        
        // Test label configurations
        XCTAssertEqual(cell.symbolLabel.text, "AAPL", "Symbol label should match stock symbol")
        XCTAssertEqual(cell.quantityValueLabel.text, "10", "Quantity label should match stock quantity")
        XCTAssertEqual(cell.lastTradedPriceValueLabel.text, mockStock.ltp.withFormattedCurrency,
                       "Last traded price label should be correctly formatted")
        
        // Test profit and loss calculation and color
        let expectedPnL = (-17.50).withFormattedCurrency
        XCTAssertEqual(cell.profitAndLossValueLabel.text, expectedPnL,
                       "Profit and loss label should be correctly calculated")
    }
    
    func testProfitLossColorPositive() {
        // Mock a stock with positive profit
        let mockStock = Stock(symbol: "GOOGL", quantity: 5, ltp: 100.00, avgPrice: 120.0, close: 105.00)
        cell.configure(with: mockStock)
        
        XCTAssertEqual(cell.profitAndLossValueLabel.textColor, .systemGreen,
                       "Positive profit should be green")
    }
    
    func testProfitLossColorNegative() {
        // Mock a stock with negative profit
        let mockStock = Stock(symbol: "MSFT", quantity: 7, ltp: 250.00, avgPrice: 120.0, close: 245.00)
        cell.configure(with: mockStock)
        
        XCTAssertEqual(cell.profitAndLossValueLabel.textColor, .systemRed,
                       "Negative profit should be red")
    }
    
    func testProfitLossColorNeutral() {
        // Mock a stock with no profit change
        let mockStock = Stock(symbol: "AMZN", quantity: 3, ltp: 120.00, avgPrice: 120.0, close: 120.00)
        cell.configure(with: mockStock)
        
        XCTAssertEqual(cell.profitAndLossValueLabel.textColor, .systemGreen,
                       "No profit change should use default label color")
    }
    
    func testLabelStyles() {
        // Check styles of different labels
        XCTAssertEqual(cell.symbolLabel.font.pointSize, 22, "Symbol label should have 22pt font")
        XCTAssertEqual(cell.symbolLabel.font, .systemFont(ofSize: 22, weight: .medium), "Symbol label should have medium weight")
        
        // Verify small font labels
        XCTAssertEqual(cell.quantityTitleLabel.font, .preferredFont(forTextStyle: .caption1),
                       "Quantity title should use caption1 style")
        XCTAssertEqual(cell.quantityTitleLabel.textColor, .secondaryLabel,
                       "Quantity title should use secondary label color")
        
        // Verify large value labels
        XCTAssertEqual(cell.quantityValueLabel.font, .preferredFont(forTextStyle: .headline),
                       "Quantity value should use headline style")
        XCTAssertEqual(cell.quantityValueLabel.textColor, .label,
                       "Quantity value should use default label color")
    }
    
    func testStaticLabels() {
        XCTAssertEqual(cell.quantityTitleLabel.text, "NET QTY:",
                       "Quantity title label should have correct static text")
        XCTAssertEqual(cell.lastTradedPriceTitleLabel.text, "LTP:",
                       "Last traded price title label should have correct static text")
        XCTAssertEqual(cell.profitAndLossTitleLabel.text, "P&L:",
                       "Profit and loss title label should have correct static text")
    }
}
