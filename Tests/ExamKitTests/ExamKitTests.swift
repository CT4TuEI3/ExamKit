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
        
        for ticket in tickets {
            XCTAssertEqual(ticket.category, .abm)
            XCTAssertGreaterThan(ticket.questions.count, 0)
            
            for question in ticket.questions {
                XCTAssertFalse(question.question.isEmpty)
                XCTAssertGreaterThan(question.answers.count, 0)
                XCTAssertFalse(question.id.isEmpty)
            }
        }
    }
    
    func testLoadTicketsForCD() throws {
        let tickets = try ExamKit.getTickets(for: .cd)
        XCTAssertGreaterThan(tickets.count, 0)
        
        for ticket in tickets {
            XCTAssertEqual(ticket.category, .cd)
            XCTAssertGreaterThan(ticket.questions.count, 0)
            
            for question in ticket.questions {
                XCTAssertFalse(question.question.isEmpty)
                XCTAssertGreaterThan(question.answers.count, 0)
                XCTAssertFalse(question.id.isEmpty)
            }
        }
    }
    
    func testTicketsAreSorted() throws {
        let tickets = try ExamKit.getTickets(for: .abm)
        let numbers = tickets.map { Int($0.number.filter { $0.isNumber }) ?? 0 }
        XCTAssertEqual(numbers, numbers.sorted(), "Билеты должны быть отсортированы по номеру")
    }
    
    func testDataServiceReturnsTickets() throws {
        let dataService = DataService.shared
        let tickets = try dataService.loadTickets(for: .abm)
        XCTAssertFalse(tickets.isEmpty)
    }
    
    func testLoadTopicsForAB() throws {
        let topics = try ExamKit.getTopics(for: .abm)
        XCTAssertGreaterThan(topics.count, 0)
        XCTAssertEqual(topics.first?.category, .abm)
        
        for topic in topics {
            XCTAssertGreaterThan(topic.questions.count, 0)
            for question in topic.questions {
                XCTAssertFalse(question.originalID.isEmpty)
            }
        }
    }
    
    func testLoadTopicsForCD() throws {
        let topics = try ExamKit.getTopics(for: .cd)
        XCTAssertGreaterThan(topics.count, 0)
        XCTAssertEqual(topics.first?.category, .cd)
        
        for topic in topics {
            XCTAssertGreaterThan(topic.questions.count, 0)
            for question in topic.questions {
                XCTAssertFalse(question.originalID.isEmpty)
            }
        }
    }
    
#if canImport(UIKit)
    func testQuestionImageLoading() throws {
        let tickets = try ExamKit.getTickets(for: .abm)
        if let firstQuestion = tickets.first?.questions.first {
            XCTAssertNoThrow({
                _ = firstQuestion.image
            }())
        }
    }
    
    func testImageService() throws {
        let tickets = try ExamKit.getTickets(for: .abm)
        if let firstQuestion = tickets.first?.questions.first {
            XCTAssertNoThrow({
                _ = ImageService.shared.loadImage(for: firstQuestion)
            }())
        }
    }
#endif
}
