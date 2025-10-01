# ExamKit

![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange)
![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen)
![Release](https://img.shields.io/github/v/release/CT4TuEI3/ExamKit)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![GitHub stars](https://img.shields.io/github/stars/CT4TuEI3/ExamKit)

Swift Package Manager библиотека для работы с экзаменационными билетами ПДД.

## Использование

### Основной API

```swift
import ExamKit

// Получение билетов для категории A,B
let tickets = try ExamKit.getTickets(for: .abm)

// Получение билетов для категории C,D
let tickets = try ExamKit.getTickets(for: .cd)
```


## Модели данных

### ExamCategory
Перечисление категорий экзамена:
- `.abm` - категории A, B
- `.cd` - категории C, D

### Answer
Структура ответа:
- `answerText: String` - текст ответа
- `isCorrect: Bool` - правильность ответа

### Question
Структура вопроса:
- `title: String` - заголовок
- `ticketNumber: String` - номер билета
- `ticketCategory: String` - категория билета
- `imagePath: String` - путь к изображению
- `question: String` - текст вопроса
- `answers: [Answer]` - варианты ответов
- `correctAnswer: String` - правильный ответ
- `answerTip: String` - подсказка
- `topic: [String]` - темы
- `id: String` - уникальный идентификатор
- `image: UIImage?` - **загруженное изображение (только для iOS)**

### Ticket
Структура билета:
- `number: String` - номер билета
- `category: ExamCategory` - категория
- `questions: [Question]` - вопросы


## Требования

- iOS 13.0+
- Swift 5.9+


## Установка

### Swift Package Manager

```swift
dependencies: [
    .package(path: "path/to/ExamKit")
]
```

## Тестирование

```bash
swift test
```
