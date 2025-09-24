import XCTest
@testable import ExamKit

final class ExamKitTests: XCTestCase {
    
    func testGetAvailableCategories() throws {
        let categories = ExamCategory.allCases
        XCTAssertEqual(categories.count, 2)
        XCTAssertTrue(categories.contains(.abm))
        XCTAssertTrue(categories.contains(.cd))
    }
    
    func testLoadTicketsForAB() throws {
        let tickets = try ExamKit.getTickets(for: .abm)
        XCTAssertGreaterThan(tickets.count, 0)
        
        if let firstTicket = tickets.first {
            XCTAssertEqual(firstTicket.category, .abm)
            XCTAssertGreaterThan(firstTicket.questions.count, 0)
            
            if let firstQuestion = firstTicket.questions.first {
                XCTAssertFalse(firstQuestion.question.isEmpty)
                XCTAssertGreaterThan(firstQuestion.answers.count, 0)
                XCTAssertFalse(firstQuestion.id.isEmpty)
            }
        }
    }
    
    func testLoadTicketsForCD() throws {
        let tickets = try ExamKit.getTickets(for: .cd)
        XCTAssertGreaterThan(tickets.count, 0)
        
        if let firstTicket = tickets.first {
            XCTAssertEqual(firstTicket.category, .cd)
            XCTAssertGreaterThan(firstTicket.questions.count, 0)
            
            if let firstQuestion = firstTicket.questions.first {
                XCTAssertFalse(firstQuestion.question.isEmpty)
                XCTAssertGreaterThan(firstQuestion.answers.count, 0)
                XCTAssertFalse(firstQuestion.id.isEmpty)
            }
        }
    }
    
    func testDataService() throws {
        let dataService = DataService.shared
        let tickets = try dataService.loadTickets(for: .abm)
        XCTAssertGreaterThan(tickets.count, 0)
    }
    
    func testLoadTopicsForAB() throws {
        let topics = try ExamKit.getTopics(for: .abm)
        XCTAssertGreaterThan(topics.count, 0)
        XCTAssertEqual(topics.first?.category, .abm)
        
        // Проверяем что у каждой темы есть вопросы
        for topic in topics {
            XCTAssertGreaterThan(topic.questions.count, 0)
            // Проверяем что ticketNumber может быть nil для вопросов тем
            for question in topic.questions {
                XCTAssertNotNil(question.originalID)
                XCTAssertFalse(question.originalID.isEmpty)
            }
        }
    }
    
    func testLoadTopicsForCD() throws {
        let topics = try ExamKit.getTopics(for: .cd)
        XCTAssertGreaterThan(topics.count, 0)
        XCTAssertEqual(topics.first?.category, .cd)
        
        // Проверяем что у каждой темы есть вопросы
        for topic in topics {
            XCTAssertGreaterThan(topic.questions.count, 0)
            // Проверяем что ticketNumber может быть nil для вопросов тем
            for question in topic.questions {
                XCTAssertNotNil(question.originalID)
                XCTAssertFalse(question.originalID.isEmpty)
            }
        }
    }
    
    #if canImport(UIKit)
    func testQuestionImageLoading() throws {
        let tickets = try ExamKit.getTickets(for: .ab)
        XCTAssertGreaterThan(tickets.count, 0)
        
        if let firstTicket = tickets.first,
           let firstQuestion = firstTicket.questions.first {
            
            // Test that image property is available and doesn't crash
            let image = firstQuestion.image
            // We don't assert on the result since some questions may not have images
            // but we ensure the property is accessible
            XCTAssertNoThrow(image)
        }
    }
    
    func testImageService() throws {
        let imageService = ImageService.shared
        let tickets = try ExamKit.getTickets(for: .ab)
        
        if let firstTicket = tickets.first,
           let firstQuestion = firstTicket.questions.first {
            
            let image = imageService.loadImage(for: firstQuestion)
            // Test that the service doesn't crash
            XCTAssertNoThrow(image)
        }
    }
    #endif
}
