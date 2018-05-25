import System.IO

-- | Definition of the regular expression type class.
class Regex a where
  -- | The initial state of the regular expression.
  startRegex :: a
  -- | The transition function, which updates the state based on the next
  --   character.
  thenChar :: a -> Char -> a
  -- | Indicate whether the current state is an /accepting state/.
  isMatch :: a -> Bool

-- | Parse a string and return the final state of the regular expression.
parse :: Regex a => String -> a
parse str = parse' startRegex str
  where
    parse' re [] = re
    parse' re (c:cs) = parse' (thenChar re c) cs

-- | Data type for the regular expression "(ab)*".
data AB = ThenA | ThenB | InvalidAB deriving (Eq, Show)

instance Regex AB where
  startRegex = ThenA
  thenChar state ch
    | state == ThenA = if ch == 'a' then ThenB else InvalidAB
    | state == ThenB = if ch == 'b' then ThenA else InvalidAB
    | otherwise      = InvalidAB
  isMatch state = state == ThenA

-- | Data type for the regular expression "ab(ab)*".
data ABAB =
    FirstA      -- ^ Awaiting the first 'a' character.
  | FirstB      -- ^ Awaiting the first 'b' character.
  | ExtraA      -- ^ Awaiting any extra 'a' character.
  | ExtraB      -- ^ Awaiting any extra 'b' character.
  | InvalidABAB -- ^ Encountered an unexpected character.
  deriving (Eq, Show)

instance Regex ABAB where
  startRegex = FirstA

  thenChar FirstA 'a' = FirstB
  thenChar FirstB 'b' = ExtraA
  thenChar ExtraA 'a' = ExtraB
  thenChar ExtraB 'b' = ExtraA
  thenChar _ _        = InvalidABAB

  isMatch ExtraA = True
  isMatch _ = False

-- | Data type for the regular expression "a..b".
data AxxB =
    Start       -- ^ Awaiting the first 'a' character.
  | AnyChar1    -- ^ Awaiting the first wild-card character.
  | AnyChar2    -- ^ Awaiting the first wild-card character.
  | NeedB       -- ^ Awaiting the final 'b' character.
  | End         -- ^ Received the final 'b' character.
  | InvalidAxxB -- ^ Encountered an unexpected character.
  deriving (Eq, Show)

instance Regex AxxB where
  startRegex = Start

  thenChar Start 'a' = AnyChar1
  thenChar AnyChar1 _ = AnyChar2
  thenChar AnyChar2 _ = NeedB
  thenChar NeedB 'b' = End
  thenChar _ _ = InvalidAxxB

  isMatch End = True
  isMatch _ = False

-- | Load this module in GHCi and evaluate 'main' to test input strings
--   against each of these regular expressions.
main :: IO ()
main = do
  putStr "Enter a string: "
  hFlush stdout
  string <- getLine
  let match1 = isMatch (parse string :: AB)
      match2 = isMatch (parse string :: ABAB)
      match3 = isMatch (parse string :: AxxB)
  putStrLn $ "Does '" ++ string ++ "' match '(ab)*'?    " ++ show match1
  putStrLn $ "Does '" ++ string ++ "' match 'ab(ab)*'?  " ++ show match2
  putStrLn $ "Does '" ++ string ++ "' match 'a..b'?     " ++ show match3
