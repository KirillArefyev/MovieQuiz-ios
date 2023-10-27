import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var textOfQuestionLabel: UILabel!
    @IBOutlet private weak var indexOfQuestionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Private Properties
    private var presenter: MovieQuizPresenter!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }
    // MARK: - Methods
    func showStep(_ step: QuizStepViewModel) {
        moviePosterImageView.image = step.image
        moviePosterImageView.layer.borderColor = UIColor.clear.cgColor
        textOfQuestionLabel.text = step.question
        indexOfQuestionLabel.text = step.questionNumber
        hideLoadingIndicator()
    }
    
    func enableButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func disableButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        moviePosterImageView.layer.masksToBounds = true
        moviePosterImageView.layer.borderWidth = 8
        moviePosterImageView.layer.cornerRadius = 20
        disableButtons()
        if isCorrectAnswer == true {
            moviePosterImageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            moviePosterImageView.layer.borderColor = UIColor.ypRed.cgColor
        }
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Actions
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        presenter.noButtonTapped()
    }
    
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        presenter.yesButtonTapped()
    }
}
