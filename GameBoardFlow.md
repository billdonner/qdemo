 

# QANDA Game

The QANDA (Question and Answer) Game presents a serious of multiple choice questions to a single player on a grid. The player answers questions in any order, completing the board by answering adjacent (including diagonal) questions correctly until both ends of either diagonal of the board  have been connected. The player is given a small number of "gimmees" at the start of the game. Each gimmee allows the player to replace a particular question with another question to avoid incorrectly answering a question.

## Game Data

The database for QANDA is periodically fully downloaded by the mobile app and the game is played locally until all questions and topics are exhausted. The data has been cleaned and verified for accuracy. 

When a new database is downloaded in the background by the mobile app the player is given an opportunity between games  to switch to the new data.

## Topics 

There are between 3 and 9 Topics active in the Game at any point in time, depending on board size and player preferences. For the purposes of this document they are just names of categories like Movies,Music,Food, or very specifically German Movies of the 20's and 30's .  

### Challenges

Challenges are questions and answers for the player. Challenges are organized into Topics through multiple mechanisms including by the remote Chatbot, or by a human user or script. Each challenge has a difficulty level of (easy,normal,hard), or absent a particular difficulty the challenge is considered "normal". Each challenge has four multiple choice answers and is typically presented as a dialog box. 

- On the gameboard, each   Cell is normally marked as ".unplayed"

- Choosing a correct answer  is worth a point and marks the Cell as ".correct" 

- Choosing an incorrect answer scores no points and marks the Cell as ".incorrect" 

- Challenge remains on screen until the user dismisses the dialog box.

### Sufficiency of Challenges

There will be no topics with less than 100 possible questions. Each question is marked as it is answered so it will not be immediately presented to the user again in subsequent games, even when playing questions in the same topic. Questions can  repeat if the player initially answered them incorrectly, ensuring the pool never technically runs dry.


### Selection of Topics 

Only at app start and between games the player can Choose New Topics for the next game via a simple dual list user interface. 

At more advanced levels the Game will randomly choose some topics for player before the player chooses the rest. The player can "reroll" any of the random topics once - in this case a different random topic is chosen. 

The presence of questions from these topics is intended to make the game more difficult but each level will have at least one "easy" topic.


The player can additionally choose up to N-M topics where N is the size of the matrix side, and M is number of pre-chosen topics.

Every board will have at most  2*N - M - 3 topics


- 3x3 has no pre-chosen topics and at most 3 user chosen topics
- 4x4 has one pre-chosen topic and at most four user chosen
- 5x5 has two pre-chosen topics and at most five user chosen
- 6x6 has three pre-chosen topics and at most six user chosen


Therefore there are at most nine different topics in any particular game, and at least three.


### Topic colorization of cells

Each topic has a color assigned at the start of game. All cells will be colored by the color associated by their topic. At most nine colors are required to color the game. 

The game is supplied with a collection of Color Palettes - each of which defines the required colors for the different board sizes. 

A small legend at the bottom of the main screen will reflect the topics colorization scheme in effect for the game


## Game Board and Flow

The board is just a square matrix of cells. Within each cell is a Challenge, categorized and possibly colorized by its topic.

It is anticipated that reasonable game dimensions will be at least 3 cells square and at most 6

The goal of the game is to complete a path of adjacent ".correct" cells from any corner to its diagonally oppositte corner. A real-time pathfinding algorithm  checks if there is still a possible winning path after each move. If no possible path exists notify the player is notified immediately.

The game is lost when there is no winning path possible on the board and the number of gimmees is 0.

In the basic game the first move can be any cell on the board. An advanced game cell requires the first move to be one of the four corner cells.

Each new move must be adjacent to any previously successfully answered cell. Adjacency is defined as the eight cells touching an interior cell within the game 

 
## Gimmees

At the start of the game the player is given N-2 "gimmees" where N is the dimension of the game. So the three game gets one on the six game gets four.

The player activates the gimmee logic via a long press on any ".unplayed" cell when the player still has 1 or more gimmee. If the player uses up all their gimmees longpress is ineffective and if there is no winning path possible the player is informed via an Alert that the game is lost. 

When successfully activated, the player can swap out the challenge in a particular cell for unplayed challenge from the same topic or a different topic.  This is a total replacement of the question and its answers, 

When there are no unplayed challenges in the same topic the player is andomly given a  question from the remaining topics.

 if there are no unplayed questions, a previously seen question (that the player got wrong) can be used


### Difficulty Levels

The player must select a difficulty level of (easy,normal,hard). Some consideration will be given the difficulty of the challenges presented to the user. Eventually we will use machine learning but for now we'll use a fixed algorithm that tries to match user  level with challenge Difficulty Level

These are optional: 

- A more difficult version of all game variants requires the first move to occur in a corner cell. This adds two "gimmees" to player's next game.

- Another difficult version of all game variants requires both diagonals to be completed. This adds three gimmees to player;s next game.


### Workflow Overview

1. **Game Initialization**:
  
   - The game and player select topics.
   - The game board is initialized.

2. **Gameplay**:
   - The user taps a cell to reveal a question.
   - Upon answering, the cell is marked as `.correct` or `.incorrect`.
   - The board’s state is updated and checked for possible winning paths.
   - The user can use a "gimmee" by long-pressing a cell.
   - The game proceeds until either a winning path is created, no winning path is possible, or the user decides to reset or switch topics.

3. **End of Game**:
   - The player is offered to start a new game, either with new topics or the same.



## Onboarding

The player can exit from Onboarding directly to the first simplest 3x3 game at any point.

The entire onboarding sequence can be replayed via the Help function. 

### Panel 1: Welcome & Objective
- **Title:** Welcome to QANDA Game!
- **Content:** Provide a brief overview of the game and its main objective.
  - "Welcome to QANDA! In this game, you'll answer trivia questions to connect two diagonal corners on a grid. Answer questions correctly to complete a path from one corner to its opposite corner."

### Panel 2: Game Board & Topics
- **Title:** Game Board & Topics
- **Content:** Explain the game board layout and how topics are organized and color-coded.
  - "Each game board is a grid of cells with questions inside. Each cell is color-coded by topic. Choose and answer questions in any order, but you must create a continuous path of correct answers from corner to corner!"
  
  ### Panel 2a: Selecting Topics
- **Title:** Selecting Topics
- **Content:** Explain the topic screen how topics are organized and color-coded.
  - "You can choose some topics, but we will choose the others. If you dont like our choices, you can re-roll them once!  We'll pick the colors or you can choose your own"

### Panel 3: Answering Questions
- **Title:** Answering Questions
- **Content:** Describe the multiple-choice questions and how to interact with them.
  - "Tap any cell to see a multiple-choice question. Answer correctly to earn a point and mark the cell as correct. Incorrect answers mark the cell as incorrect. You can only move to adjacent cells next."

### Panel 4: Using Gimmees
- **Title:** Using Gimmees
- **Content:** Explain the concept of gimmees and how players can use them.
  - "You start each game with a few gimmees, which let you replace a question. Long-press an unplayed cell to use a gimmee. If you get stuck, gimmees can save the day!"

### Panel 5: Winning & Losing
- **Title:** Winning & Losing
- **Content:** Outline the win and lose conditions.
  - "To win, complete a path of correct answers from one corner to the opposite diagonal corner. The game is over if there's no possible winning path and you have no gimmees left."

### Panel 6: Difficulty Levels & Game Variants
- **Title:** Difficulty & Variants
- **Content:** Briefly describe the difficulty settings and game variants.
  - "Choose your difficulty level: easy, normal, or hard. Experiment with different game variants like 'All Questions Face Up' or 'All Questions Face Down' for extra challenges. Good luck!"


## Game Variants
There's a variety of different games that can be created on the general platform 

### 1. All Questions Face Up
In this variation the questions are obvious so as to plan a full route strategy. This is the game described above. 

### 2. All Questions Face Down
In this variation only the topic colors are shown and the questions are only seen when tapped. This variant will be fully described in the onboarding and help files.

### 11. Time Trial Mode
- **Description**: Players must complete the board within a certain time limit.
- **Mechanics**: 
  - A countdown timer is displayed on the screen.
  - Answering questions quickly can give time bonuses.
  - If the time runs out before a path is completed, the game is lost.
  - Offers an additional layer of excitement and urgency.

### 12. Fog of War
- **Description**: In this variant, only the immediate surrounding cells (adjacent and diagonal) are visible.
- **Mechanics**: 
  - As the player answers questions correctly, more cells become visible.
  - Players must strategize carefully as they navigate through the unknown sections.
  - Adds mystery and requires careful planning.

### 13. Minesweeper Mode
- **Description**: Some cells contain "mines" which reset the cell and adjacent ones as unplayed if an incorrect answer is given.
- **Mechanics**:
  - Mines remain hidden until an incorrect answer is selected.
  - Correctly answering questions reveals nearby cells without mines.
  - Gives a strategic and cautious approach to completing the board.

### 14. Chain Reaction
- **Description**: Correctly answering a cell triggers neighboring cells to automatically reveal themselves.
- **Mechanics**:
  - When a specific condition is met (e.g., answering a certain number of questions in a row correctly), adjacent cells are auto-revealed and become “correct”.
  - Encourages players to target specific areas to trigger chain reactions.

### 15. Theme Mode
- **Description**: Every game has a randomly selected theme (e.g., a specific historical period, science fiction, sports, etc.), and all questions are from this theme.
- **Mechanics**:
  - The theme is revealed at the game start.
  - Players with specialized knowledge can leverage their strengths.
  - Offers a thematic and educational element.

### 16. Progressive Difficulty
- **Description**: The difficulty of questions increases as players answer more questions correctly.
- **Mechanics**:
  - Initial questions are marked as “easy”.
  - As more cells are correctly answered, consecutive questions become “normal”, then “hard”.
  - Gradually challenges the player more as they progress.

### 17. Multiplayer Race
- **Description**: Multiple players compete simultaneously on a larger board, trying to complete their path first.
- **Mechanics**:
  - Players see their own progress and the moves of their opponents.
  - There is a shared "question pool," so a question answered by one player is not available for others.
  - Adds a competitive element and real-time interaction.

### 18. Resource Allocation Mode
- **Description**: Players have a limited number of resources (such as time, gimmees, or hints) and must strategically allocate them.
- **Mechanics**:
  - Players earn additional resources by completing mini-challenges or achieving streaks of correct answers.
  - Forces careful planning and prioritization of moves.

### 19. Hidden Path
- **Description**: The player must guess the correct path predetermined by the game but hidden at the start.
- **Mechanics**:
  - As the player answers questions, hints about the correct path are revealed.
  - Incorrect answers give misdirections.
  - A focus on pattern recognition and deduction skills.

### 20. Question Swap
- **Description**: Players earn the ability to swap questions on the board.
- **Mechanics**:
  - Answering a question correctly gives the player the option to swap its challenge with another unplayed question.
  - Provides strategic opportunities for reordering the complexity or themes of upcoming challenges.


# Game Design Analysis and Recommendations for QANDA Game

Based on the provided specifications, the QANDA game seeks to blend strategic gameplay with trivia, creating an engaging and challenging experience. Here are some detailed recommendations and considerations for various aspects of the game:

## 1. **Game Board and Flow Enhancements**

### Path Visualization
- **Path Highlighting**: Implement a highlight feature that visually traces the correct path from any corner to its diagonally opposite corner. This provides immediate feedback to the player and maintains player engagement by showing progress.
- **Dynamic Path Updates**: As cells are answered, a real-time algorithm should adjust and highlight potential paths, ensuring that players understand when they may be nearing a win or a potential loss.

### User Interface
- **Intuitive Cell Interaction**: Ensure that tapping and long-pressing actions are intuitive. Consider adding a slight animation or color change on long press to denote that a gimmee can be used.
- **Progress Bar**: A visual progress bar could be added to give players a quick glance at their overall progress towards connecting the corners.

## 2. **Topic and Question Management**

### Randomization and Variety
- **Balanced Topic Distribution**: Ensure that topics are evenly distributed across the board to avoid clustering, which can make certain areas of the board disproportionately difficult.
- **Dynamic Question Pool**: Enhance replayability by ensuring a vast pool of questions and regularly updating the database. Periodically introduce new and timely topics to keep the game fresh.

### Advanced Topic Selection
- **Player Skill Adaptation**: As players progress to higher levels, consider adapting the difficulty and topics based on their performance history. For example, a player who excels in specific topics might see more challenging questions in those areas.

## 3. **Game Variants Implementation**

### Time Trial Mode
- **Timer Mechanics**: Introduce time-based power-ups like "Time Extension" for correct answers or "Freeze Time" as rewards for streaks of correct answers. This can keep the time-bound gameplay thrilling.
- **Leaderboard**: Incorporate leaderboards for players who complete the time trial fastest, aiming for competitive spirit and replayability.

### Fog of War
- **Visibility Mechanics**: Enhance the mystery aspect by allowing players to earn temporary visibility boosts, uncovering larger portions of the board for a brief period.
- **Strategic Planning**: Encourage careful planning by introducing "fog-clear" power-ups that gradually reveal parts of the board as milestones are reached.

### Minesweeper Mode
- **Risk Management**: Allow players to earn tools to detect mines, such as "Mine Detectors" that can scan adjacent cells before answering. This adds a tactical layer for cautious players.
- **Penalty Mechanism**: Define clear consequences for triggering mines and provide "repair kits" that allow players to recover exploded cells after a penalty.

### Chain Reaction
- **Trigger Points**: Clearly define and highlight cells with potential chain reactions, encouraging players to target these cells strategically.
- **Combo Bonuses**: Reward players with combo bonuses for triggering multiple chain reactions within a limited number of moves.

## 4. **Onboarding and Tutorial Adjustments**

### Interactive Tutorial
- **Step-by-Step Guide**: Develop an interactive tutorial that guides players through their first game, explaining key elements such as answering questions, using gimmees, and understanding the win conditions.
- **Contextual Hints**: Provide hints during early gameplay, especially when a player appears to struggle with understanding game mechanics or strategies.

### Progressive Onboarding
- **Gradual Complexity**: Introduce game variants gradually as players become more comfortable with the basic gameplay. Allow them to unlock variants through achievements or progress milestones.
- **Example Scenarios**: Use example scenarios to demonstrate advanced strategies, such as using gimmees or planning a pathway under stricter conditions.

## 5. **Difficulty Levels and Adaptive Gameplay**

### Dynamic Difficulty Adjustment
- **Performance-Based Scaling**: Create algorithms that adjust the difficulty of questions based on player performance. For instance, players who consistently answer correctly should face increasingly difficult questions to maintain challenge.
- **Motivational Rewards**: Provide rewards for playing on higher difficulty settings, such as unlockable content, additional gimmees, or exclusive leaderboard placements.

### Expert Mode
- **Advanced Pathfinding**: Introduce an "Expert Mode" where players must complete both diagonals or face more intricate pathfinding challenges. Reward successful completion with higher scores and exclusive achievements.
- **Skill-Based Challenges**: Consider integrating periodic skill-based challenges or tournaments where players compete in expert mode for higher stakes and unique rewards.

## 6. **Multiplayer and Social Features**

### Multiplayer Race Mode
- **Real-Time Competition**: Create a real-time multiplayer mode where players can see each other’s progress. Implement a chat feature or quick emotes for interaction.
- **Shared Question Pool**: Ensure fair play by rotating questions frequently, preventing any single player from gaining an advantage through question repetition.

### Social Sharing
- **Achievement Sharing**: Allow players to share their achievements and high scores on social media platforms to encourage competition and attract new players.
- **Friend Challenges**: Introduce a feature where players can challenge friends directly, compare progress, and share strategies.

By implementing these recommendations, QANDA Game can provide a more engaging, challenging, and enjoyable experience, driving higher player retention and satisfaction.
