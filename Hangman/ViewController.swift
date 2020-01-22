//
//  ViewController.swift
//  Hangman
//
//  Created by Noah Braunfeld (student HH) on 1/16/20.
//  Copyright © 2020 Noah Braunfeld (student HH). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var treeImageView: UIImageView!
	@IBOutlet var correctWordLabel: UILabel!
	@IBOutlet var scoreLabel: UILabel!
	@IBOutlet var letterButtons: [UIButton]!
	
	var listOfWords: [String] = []
	let incorrectMovesAllowed = 7
	var totalWins = 0 {
		didSet {
			newRound()
		}
	}
	var totalLosses = 0 {
		didSet {
			newRound()
		}
	}
	
	var currentGame: Game!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		loadJSON()
		newRound()
	}

	@IBAction func buttonTapped(_ sender: UIButton) {
		sender.isEnabled = false
		let letterString = sender.title(for: .normal)
		let letter = Character(letterString!.lowercased())
		currentGame.playerGuessed(letter: letter)
		updateGameState()
	}
	
	func updateGameState() {
		if currentGame.incorrectMovesRemaining == 0 {
			totalLosses += 1
		} else if currentGame.word == currentGame.formattedWord {
			totalWins += 1
		} else {
			updateUI()
		}
	}
	
	func newRound() {
		if !listOfWords.isEmpty {
			let index = Int.random(in: 0..<listOfWords.count)
			let newWord = listOfWords.remove(at: index)
			currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
			enableLettersButton(true)
			updateUI()
		} else {
			enableLettersButton(false)
		}
	}
	
	func enableLettersButton(_ enable: Bool) {
		for buttons in letterButtons {
			buttons.isEnabled = enable
		}
	}
	
	func updateUI() {
		var letters = [String]()
		for letter in currentGame.formattedWord {
			letters.append(String(letter))
		}
		let wordWithSpacing = letters.joined(separator: " ")
		correctWordLabel.text = wordWithSpacing
		scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
		treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
	}
	
	func loadJSON() {
		if let path = Bundle.main.path(forResource: "wordlist", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
				let jsonData = try JSONDecoder().decode(WordList.self, from: data)
				// print(jsonData.listOfWords)
				self.listOfWords = jsonData.listOfWords
			} catch {
				print("error")
			}
		}
	}
}

struct WordList: Codable {
	var listOfWords: [String]
}
