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
    
    func testLoadMarkups() throws {
        let markups = try ExamKit.getMarkups()
        XCTAssertGreaterThan(markups.count, 0, "Должны быть категории разметки")
        XCTAssertEqual(markups.count, 2, "Ожидается 2 категории: Горизонтальная и Вертикальная")
        
        for category in markups {
            XCTAssertFalse(category.name.isEmpty, "Название категории не должно быть пустым")
            XCTAssertGreaterThan(category.markups.count, 0, "В категории должны быть разметки")
            
            for markup in category.markups {
                XCTAssertFalse(markup.number.isEmpty, "Номер разметки не должен быть пустым")
                XCTAssertFalse(markup.description.isEmpty, "Описание разметки не должно быть пустым")
                XCTAssertFalse(markup.imagePath.isEmpty, "Путь к изображению не должен быть пустым")
                XCTAssertTrue(markup.imagePath.hasSuffix(".png"), "Изображения должны быть в формате PNG")
            }
        }
    }
    
    func testMarkupsAreSorted() throws {
        let markups = try ExamKit.getMarkups()
        
        for category in markups {
            let numbers = category.markups.map { $0.number }
            
            // Проверяем, что номера идут в правильном порядке (1.1, 1.2, ..., 1.10, 1.11, ...)
            for i in 0..<(numbers.count - 1) {
                let current = numbers[i]
                let next = numbers[i + 1]
                
                let currentParts = current.split(separator: ".").compactMap { Int($0) }
                let nextParts = next.split(separator: ".").compactMap { Int($0) }
                
                // Проверяем, что следующий номер больше или равен текущему
                if currentParts.count > 0 && nextParts.count > 0 {
                    if currentParts[0] == nextParts[0] {
                        if currentParts.count > 1 && nextParts.count > 1 {
                            XCTAssertLessThanOrEqual(currentParts[1], nextParts[1], 
                                "Разметки должны быть отсортированы: \(current) должен быть <= \(next)")
                        }
                    }
                }
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
    
    func testMarkupImageLoading() throws {
        let markups = try ExamKit.getMarkups()
        
        if let firstMarkup = markups.first?.markups.first {
            XCTAssertNoThrow({
                _ = firstMarkup.image
            }())
            
            // Проверяем, что хотя бы одно изображение загрузилось
            let hasLoadedImage = markups.flatMap { $0.markups }.contains { $0.image != nil }
            XCTAssertTrue(hasLoadedImage, "Хотя бы одно изображение разметки должно загрузиться")
        }
    }
#endif
}
