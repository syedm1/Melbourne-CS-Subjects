module Phantom (UserData(), userData, validate, process, runTest) where

import Data.Maybe (fromJust)
import Data.List (intercalate)

-- | We don't export the definition of this data type, so the only way for
--   code that is outside of this module to create values of this type is
--   to use the 'userData' function (defined below).
data UserData a = PrivateData String

-- | These are our 'phantom types' --- they don't change anything about the
--   values stored in the 'UserData' type, but they act as identifiers that
--   can *only* be changed by functions inside this module.
data Unvalidated
data Validated

-- | This function takes a string and returns an 'Unvalidated' value.
userData :: String -> UserData Unvalidated
userData str = PrivateData str

-- | This function represents an action, such as querying a database, where
--   it is critical that the input values have been validated. So it only
--   accepts 'Validated' values.
process :: UserData Validated -> IO ()
process (PrivateData validStr) = putStrLn validStr

-- | The only way to generate a 'Validated' value is to use this function,
--   which performs all of the necessary checks and conversions. Note that
--   it may not always succeed.
--
-- For the purposes of this demonstration, let's assume that the validation
-- process means replacing all whitespace and line breaks with '%20' (the
-- way that spaces are encoded in URLs).
validate :: UserData Unvalidated -> Maybe (UserData Validated)
validate (PrivateData str) =
  let word_list = words str
      joined_words = intercalate "%20" word_list
  in
    Just $ PrivateData joined_words

-- | Here's an example of validating the user input (which contains spaces
--   and line breaks) before processing it.
runTest :: IO ()
runTest = do
  let input = "hello world\nthis has\nmultiple lines"
  let user_input = userData input
  let maybe_valid = validate user_input
  process $ fromJust maybe_valid

-- In GHCi:
--   :l Phantom
--   :m
--   :m Phantom
