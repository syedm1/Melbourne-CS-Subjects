module ChessGuess (initialGuess, nextGuess, GameState) where

-- | The different kinds of chess pieces.
data Kind = King | Queen | Rook | Knight | Bishop | Pawn
          deriving (Eq, Ord, Bounded, Enum)

-- | Each chess piece has a colour and a kind.
--
-- Note that we __don't__ need to define a separate 'Colour' type!
data Piece = Black Kind | White Kind
           deriving (Eq)

-- | A guess is simply a list of chess pieces.
type Guess = [Piece]

-- | The score represents:
--
--     * The number of pieces that have the correct kind __and__ colour.
--     * The number of pieces that __only__ have the correct kind.
--     * The number of pieces that __only__ have the correct colour.
type Score = (Int, Int, Int)

-- | The maximum number of pieces that could be hidden.
type Size = Int

-- | The state of our guesser.
data GameState =
    GameSize Size
    -- ^ To begin with, we only know the game size.
  | GuessedBP Size Score
    -- ^ After the initial guess (all black pawns), we know the game size and
    --   the score of the initial guess.
  | UsingMinimax Guess [Guess]
    -- ^ After the second guess (all white bishops), the number of valid
    --   solutions should be small enough (no matter the game size) that we
    --   can use the minimax algorithm.

-- | Return the initial guess and the initial game state.
initialGuess :: Int -> ([String], GameState)
initialGuess size = (map show guess, GameSize size)
  where
    guess = take size $ repeat (Black Pawn)

-- | Return the __next__ guess and the __next__ game state.
nextGuess :: ([String], GameState) -> Score -> ([String], GameState)
nextGuess (guessStr, prevState) score = (map show guess, nextState)
  where
    (guess, nextState) = case prevState of
      GameSize size ->
        (take size $ repeat (White Bishop), GuessedBP size score)
      GuessedBP size bpScore ->
        -- Now that we have the scores of the first two guesses, we can switch
        -- to using the minimax algorithm.
        let validSolutions = solutionsFor bpScore score
            (bestGuess, newCandidates) = minimax validSolutions
        in
          (bestGuess, UsingMinimax bestGuess newCandidates)
      UsingMinimax prevGuess candidates ->
        let
          validSolutions = filterCandidates candidates prevGuess score
          (bestGuess, newCandidates) = minimax validSolutions
        in
          (bestGuess, UsingMinimax bestGuess newCandidates)

-- | Return all possible solutions that are consistent with the scores of the
--   first two guesses, where the first guess consisted of black pawns and the
--   second guess consisted of white bishops.
solutionsFor :: Score -> Score -> [Guess]
solutionsFor bpScore wbScore = error "Not implemented"

-- | Remove all candidate solutions that are not consistent with the score of
--   the most recent guess.
filterCandidates :: [Guess] -> Guess -> Score -> [Guess]
filterCandidates candidates guess score = error "Not implemented"

-- | Return the best guess, and the remaining candidates, according to the
--   minimax algorithm.
minimax :: [Guess] -> (Guess, [Guess])
minimax candidates = error "Not implemented"

-- | Define how to convert 'Kind' values into strings.
instance Show Kind where show = showKind

showKind :: Kind -> String
showKind King = "K"
showKind Queen = "Q"
showKind Rook = "R"
showKind Knight = "N"
showKind Bishop = "B"
showKind Pawn = "P"

-- | Define how to convert 'Piece' values into strings.
instance Show Piece where show = showPiece

showPiece :: Piece -> String
showPiece (Black kind) = "B" ++ show kind
showPiece (White kind) = "W" ++ show kind

-- | Return the kind of a piece.
kindOf :: Piece -> Kind
kindOf (Black kind) = kind
kindOf (White kind) = kind

-- | Return whether a piece is black.
isBlack :: Piece -> Bool
isBlack (Black _) = True
isBlack (White _) = False

-- | Return whether a piece is white.
isWhite :: Piece -> Bool
isWhite p = not $ isBlack p

-- | Return how many pieces there are of a kind, for a single colour.
numKind :: Kind -> Int
numKind King = 1
numKind Queen = 1
numKind Pawn = 8
numKind _ = 2

-- | Return a list of every piece for a single colour.
allColourPieces :: (Kind -> Piece) -> Guess
allColourPieces f = concat $ map nPieces allKinds
 where
   nPieces k = take (numKind k) (repeat $ f k)
   allKinds = reverse [minBound::Kind ..]

-- | Return a list of every piece of both colours.
allPieces :: Guess
allPieces = allColourPieces Black ++ allColourPieces White
