import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        let moviesLoder: MoviesLoading = MoviesLoader()
        let questionFactory = QuestionFactory(moviesLoader: moviesLoder, delegate: self)
        self.questionFactory = questionFactory
        questionFactory.loadData()
    }

    // MARK: - Variables
    lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewController: self)

    private var statisticService: StatisticServiceProtocol = StatisticService()

    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10  // Количество вопросов в игре

    private var questionFactory: QuestionFactoryProtocol?

    private var currentQuestion: QuizQuestion?

    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!

    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        buttons(enable: false)
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        buttons(enable: false)
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }

    // MARK: - Private functions

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)

        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }

    private func showNetworkError(message: String) {
        activityIndicator.stopAnimating()

        let alert = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                activityIndicator.startAnimating()
                self.questionFactory?.loadData()
            }
        alertPresenter.show(alertModel: alert)
    }

    func didLoadDataFromServer() {
        activityIndicator.stopAnimating()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }

    private func buttons(enable: Bool) {
        yesButton.isEnabled = enable
        noButton.isEnabled  = enable
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }

    private func show(quiz step: QuizStepViewModel) {
        activityIndicator.stopAnimating()
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки (из макета)
        let color = isCorrect ? UIColor.ypGreen : UIColor.ypRed // цвет
        imageView.layer.borderColor = color.cgColor

        correctAnswers += isCorrect ? 1 : 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }

    func nextRound() {
        self.correctAnswers = 0
        self.currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }

    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        buttons(enable: true)
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let record = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"
            let recordDateString = "\(statisticService.bestGame.date.dateTimeStringMil)"
            let averageAccuracy = "\(String(format: "%.2f", statisticService.totalAccuracy))"
            let alert = AlertModel(
                title: "Этот раунд окончен",
                message: """
                    Ваш результат: \(correctAnswers)/\(questionsAmount)
                    Количество сыгранных квизов: \(statisticService.gamesCount)
                    Рекорд: \(record) (\(recordDateString))
                    Средняя точность: \(averageAccuracy)%
                """,
                buttonText: "Сыграть ещё раз",
                completion: { self.nextRound() }
            )
            alertPresenter.show(alertModel: alert)
        } else {
            currentQuestionIndex += 1
            activityIndicator.startAnimating()
            self.questionFactory?.requestNextQuestion()
        }
    }
}
