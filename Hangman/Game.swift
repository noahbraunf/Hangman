//
//  Game.swift
//  Hangman
//
//  Created by Noah Braunfeld (student HH) on 1/16/20.
//  Copyright © 2020 Noah Braunfeld (student HH). All rights reserved.
//

import Foundation

struct Game {
	var word: String
	var incorrectMovesRemaining: Int
	var guessedLetters: [Character]
	
	var formattedWord: String {
		var guessedWord = ""
		for letter in word {
			if guessedLetters.contains(letter) {
				guessedWord += "\(letter)"
			} else {
				guessedWord += "_"
			}
		}
		return guessedWord
	}
	
	mutating func playerGuessed(letter: Character) {
		guessedLetters.append(letter)
		if !word.contains(letter) {
			incorrectMovesRemaining -= 1
		}
	}
}
