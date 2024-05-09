
# QANDA Game

The QANDA (Question and Answer) Game presents a serious of multiple choice questions to a single player on a grid. The player answers questions in any order, completing the board by answering adjacent (including diagonal) questions correctly until both ends of either diagonal of the board  have been connected.

## Topics 

There are between 1 and 26 Topics active in the Game at any point in time. For the purposes of this document they are just names of categories like Movies,Music,Food, or very specifically German Movies of the 20's and 30's . The topics are sometimes written as TopicA,TopicB,etc thru TopicZ.


### Challenges

Challenges are questions and answers for the player. Challenges are organized into Topics through multiple mechanisms including by the remote Chatbot, or by a human user or script. Each challenge has four multiple choice answers and is typically presented as a dialog box. 

- Choosing a correct answer  is worth a point and marks the Cell as Underscored.

- Choosing an incorrect answer scores no points and marks the Cell with a strikethrough.  An incorrect answer also displays an explanation of why the answer is wrong

- Challenge remains on screen until the user dismisses the dialog box.

### Sufficiency of Challenges

There will be no topics with less than 100 possible questions. Each question is marked as it is answered so it will not be presented to the user again in subsequent games, even when playing questions in the same topic. 

### Selection of Topics 

Only at app start and between games the player can Choose New Topics for the next game via a simple dual list user interface. 

At more advanced levels the Game will randomly choose some topics for player. before the players chooses the rest, 

The presence of questions from these topics is intended to make the game more difficult.

- 4x4 has no pre-chosen topics
- 5x5 and 6x6 has one 
- 7x7 and 8x8 has two
- 9x9 and 10x10 has three

The player can choose  N-M topics where N is the size of the matrix side, and M is number of pre-chosen topics.

Every board will have at least  M > 3 topics

### Topic colorization of cells

Each topic has a color assigned at the start of game. All cells will be colored by the color associated by their topic.

There are 26 fixed colors and up to 26 topic choices, each of which has a unique color within the game. 

## Game Board and Flow

The board is just a square matrix of cells. Within each cell is a Challenge, categorized and possibly colorized by its topic.

It is anticipated that reasonable game dimensions will be at least 4 cells square and at most 10

### 5x5 game starts in square 1
|   |   c1    |   c2    |   c3    |   c4    |   c5    |
|:-----:|:------:|:------:|:------:|:------:|:------:|
|   **r1**   |   1    |   2    |   3    |   4    |   5    |
| **r2**  |   6    |   7    |   8    |   9    |  10    |
|  **r3**   |  11    |  12    |  13    |  14    |  15    |
|  **r4**  |  16    |  17    |  18    |  19    |  20    |
|  **r5**  |  21    |  22    |  23    |  24    |  25    |

The cells are labelled 1-25 for these purposes but the actual game with show either a blank or colored cell, or a colored cell with a question.

### the first questions answered must be in two opposite corners:

- the first (1) and last (25) challenges must be answered correctly ; the user has 3 opportunities to hit a button to change the questions  (only for first and last) 
- a successful challenge is marked with an underscore
- an unsuccessful challenge is marked with a strike thru 
- alternately, the user can answer question 5 and 21 and form the other diagonal

### each new move must be adjacent to any successful ly answered cell
|   |   c1    |   c2    |   c3    |   c4    |   c5    |
|:-----:|:------:|:------:|:------:|:------:|:------:|
|   **r1**   |  <u>**1**</u>  |   *2*   |   3    |   4    |   5    |
| **r2**  |   *6*   |   *7*   |   8    |   9    |  10    |
|  **r3**   |  11    |  12    |  13    |  14    |  15    |
|  **r4**  |  16    |  17    |  18    |  19    |  20    |
|  **r5**  |  21    |  22    |  23    |  24    |  25    |

- Only cells 2,6, and 7 can be selected. If, for example 6 is answered successfully the next possible questions to answer are 7,11,and 12
- This step repeats until cell 25 is hit , or there's no where to go, or you get three wrong

### game ends when cell 25 is answered correctly 
|   |   c1    |   c2    |   c3    |   c4    |   c5    |
|:-----:|:------:|:------:|:------:|:------:|:------:|
|   **r1**   |  <u>**1**</u>  |   *2*   |   3    |   4    |   5    |
| **r2**  |   *6*   | <u>**7**</u>   |   8    |   9    |  10    |
|  **r3**   |  11    | <u>**12**</u>  |  13    |  14    |  15    |
|  **r4**  |  16    |  17    |  <u>**18**</u>  |  19    |  20    |
|  **r5**  |  21    |  22    |  23    |  <u>**24**</u>  |  <u>**25**</u>  |

- in this case it took six successful answers to get to cell 25
- when comparing with your friends the smallest number is best
- perhaps we should add in the number you got wrong

### or it goes poof! if you answer any 3  questions incorrectly 
|   |   c1    |   c2    |   c3    |   c4    |   c5    |
|:-----:|:------:|:------:|:------:|:------:|:------:|
|   **r1**   |  <u>**1**</u> | *2* |   3    |   4    |   5    |
| **r2**  |   *6*   | <u>**7**</u> |   8    |   9    |  10    |
|  **r3**   |  11    | <u>**12**</u>  |  ~~13~~ |  14    |  15    |
|  **r4**  |  16    |  ~~17~~ |  <u>**18**</u>  |  ~~19~~ |  20    |
|  **r5**  |  21    |  22    |  23    |  24  |  25 |

- In this case 13,17 and 19 were answered incorrectly


### or it goes poof! you run out of possible moves

This is sometime possible based on the size of board and number of incorrect answers  allowed

### or it goes poof!  if you can't answer first and last questions
 

## Difficulty Levels

This is for future consideration. For now, the difficulty is based on size of board and number of topics not chosen by the player


# Game Variants
There's a variety of different games that can be created on the general platform 

## All Questions Face Up
In this variation the questions are obvious so as to plan a full route strategy. This is the game described above. 

### All Questions Face Down
In this variation only the topic colors are shown and the questions are only seen when tapped.

### Concentration
For 4x4,6x6,8x8 only. Questions are duplicated in two random cells which must be matched by the user before the question can be answered. Both cells are marked as correct or incorrect.  If incorrect both cells are turned back over,

All questions must be initially face down, but topic colors may or may not be shown based on difficulty level.

Question pairs will be allocated at a distance of at least N/2 cells from each other if possible so as to avoid blockages for incorrect answers. 

All other rules apply and it might be easy to get all jammed up and run out of possible moves.

# GPT4 Analysis of Logical Issues

While the QANDA game's rules and structure are generally well-defined, there are a few areas where potential logical problems are present. 

1. **Topic Colorization**: The specification states that each topic has a color assigned at the start of the game and all cells will be colored according to their topic's corresponding color. However, it is not clear if the color assigned to each topic is random or follows a certain pattern. A potential issue could arise if colors are randomly assigned and two consecutive colors are visually similar, causing player confusion.

2. **Opposite Corners Rule**: The specification states that the first questions answered must be in two opposite corners. There's no clear rule about whether the player can start from any corner or if they must start from a specific one. This unclear situation could cause confusion for the players.

3. **Game Over Conditions**: The "game over" conditions appear to be abound. The game ends upon answering the last cell correctly, getting three questions wrong, running out of possible moves. The mechanism is not explained for when there's no where to go. If the branching system can potentially lead to a dead-end, this could cause the game to end unfairly. 

4. **Difficulty Levels**: The specification mentions that the difficulty levels are based on the size of the board and the number of topics not chosen by the player. However, there aren't enough details to understand how these two factors collaboratively impact the difficulty of the game.

5. **Game Variants**: There aren’t rules defined for how the game adjusts for difficulty levels in different game variants. Should the difficulty levels then be the same across all game variants, or is there a system for automatic adjustments that needs to be outlined?

6. **Selection of Topics**: The player can only choose new topics at app start and between games. If they regret the choice of topics in the middle of a game, it might be frustrating not being able to change it without restarting the game.

7. **Concentration Variant Limitations**: The specification includes rules for the game variant "Concentration" to allocate the duplicated questions at a distance from each other, but it does not specify how these distances are calculated. This could create ambiguity in the implementation.



# GPT4 Suggested Improvements

## Time-based Challenges
Implement a time-based challenge mode in which the player is required to answer each question within a certain time limit. If they fail to do so, the cell will be marked as incorrect. This mode can add an extra level of challenge and excitement for those players seeking a more pressured and fast-paced game.

## Multiple Player Mode
Introduce a mode where more than one player can participate simultaneously. They can challenge each other to complete the game board. This competition can make the game more interesting as players can compare scores and strategies. 

## Variable Difficulty Levels
Consider adding a feature where players can adjust the difficulty level of the questions according to their preference. For example, at easier levels, questions can be multiple choices with fewer options, and at harder levels, there could be multiple correct answers.

## Progression System
Add a progression system where players can gain levels or unlock achievements based on their performance. This can reward players for their continued play and make the game feel more rewarding. 

## Daily Challenge
Each day, offer a unique set of questions on a specific topic as a "Daily Challenge". This can encourage regular play and give users a reason to return to the game daily.

## Leaderboard System
Start a leaderboard system where players can compare their scores or times with others globally. This can prod a competitive spirit among the players and encourage them to play better and score higher.

## Themes and Customization
Allow users to customize their game board with different themes and their favorite colors. This personal customization can increase player engagement and make the game more visually appealing.

## Feedback System
Consider implementing an interactive feedback system where players can rate the app, suggest improvements and report bugs. This can provide a valuable resource for further optimization of the game.

## Adaptive Difficulty Setting
Introduce an adaptive difficulty setting, with the game gradually becoming more difficult as the player progresses. This can create a better learning curve and keep players consistently challenged.
