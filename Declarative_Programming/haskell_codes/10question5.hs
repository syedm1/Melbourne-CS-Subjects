import System.IO
type Phonebook = [(String,String)]

main :: IO ()
main = phonebook []

phonebook :: Phonebook -> IO ()
phonebook pbook = do
    hFlush stdout
    command <- getLine
    case words command of 
        [] -> phonebook pbook
        ((commandLetter:_):args) -> execute pbook commandLetter args

execute :: Phonebook -> Char -> [String] -> IO ()
execute pbook 'p' [] =
    printPhonebook pbook >> phonebook pbook
execute pbook 'a' [name,num] = 
    phonebook $ (name,num):pbook
execute pbook 'd' [name] = 
    phonebook $ filter (\(n,num) -> n /= name) pbook
execute pbook 'l' [name] = 
    printPhonebook (filter ((==name).fst) pbook) >> phonebook pbook
execute pbook 'q' _ = return ()

printPhonebook :: Phonebook -> IO ()
printPhonebook [] = return ()
printPhonebook ((name,num):xs) = (putStrLn $ name ++ " " ++ num) >> printPhonebook xs
