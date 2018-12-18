import 'dart:async';

class HangmanGame {
  static const int hanged = 7;

  final List<String> wordList;
  final Set<String> lettersGuessed = Set<String>();

  List<String> _wordToGuess;

  List<String> get wordToGuess => _wordToGuess;

  String get fullWord => wordToGuess.join();

  String get wordForDisplay => wordToGuess
      .map((String letter) => lettersGuessed.contains(letter) ? letter : "_")
      .join();

  bool get isWordComplete {
    for (String letter in _wordToGuess) {
      if (!lettersGuessed.contains(letter)) {
        return false;
      }
    }
    return true;
  }

  int _wrongGuesses;

  int get wrongGuesses => _wrongGuesses;

  StreamController<Null> _onWin = StreamController<Null>.broadcast();

  Stream<Null> get onWin => _onWin.stream;

  StreamController<Null> _onLose = StreamController<Null>.broadcast();

  Stream<Null> get onLose => _onLose.stream;

  StreamController<int> _onWrong = StreamController<int>.broadcast();

  Stream<int> get onWrong => _onWrong.stream;

  StreamController<String> _onCorrect = StreamController<String>.broadcast();

  Stream<String> get onCorrect => _onCorrect.stream;

  StreamController<String> _onChange = StreamController<String>.broadcast();

  Stream<String> get onChage => _onChange.stream;

  HangmanGame(List<String> words) : wordList = List<String>.from(words);

  void newGame() {
    // shuffle the word list into a random order
    wordList.shuffle();

    // break the first word from the shuffled list into a list of letters
    _wordToGuess = wordList.first.split('');

    // reset the wrong guest count
    _wrongGuesses = 0;

    // clear the set of guessed letters
    lettersGuessed.clear();

    // declare the change (new word)
    _onChange.add(wordForDisplay);
  }

  void guessLetter(String letter) {
    // store guessed letter
    lettersGuessed.add(letter);

    // if the guessed letter is present in the word, check for a win
    // otherwise, check for player death
    if (_wordToGuess.contains(letter)) {
      _onCorrect.add(letter);

      if (isWordComplete) {
        _onChange.add(fullWord);
        _onWin.add(null);
      } else {
        _onChange.add(wordForDisplay);
      }
    } else {
      _wrongGuesses++;

      _onWrong.add(_wrongGuesses);

      if (_wrongGuesses == hanged) {
        _onChange.add(fullWord);
        _onLose.add(null);
      }
    }
  }
}
