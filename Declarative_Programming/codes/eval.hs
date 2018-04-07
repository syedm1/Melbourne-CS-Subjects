data Expression
       = Var Variable
       | Num Integer
       | Plus Expression Expression
       | Minus Expression Expression
       | Times Expression Expression
       | Div Expression Expression
data Variable = A | B

eval :: Int -> Int -> Expression -> Int
eval a b (Var A) = a
eval a b (Var B) = b
eval a b (Plus expr1 expr2) = (eval a b expr1) + (eval a b expr2)
eval a b (Minus expr1 expr2) = (eval a b expr1) - (eval a b expr2)
eval a b (Times expr1 expr2) = (eval a b expr1) * (eval a b expr2)
eval a b (Div expr1 expr2) = (eval a b expr1) `div` (eval a b expr2)
