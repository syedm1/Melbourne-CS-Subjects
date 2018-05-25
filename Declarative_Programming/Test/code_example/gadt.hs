{-# LANGUAGE GADTs #-}

-- | We can represent integers, and arithmetic operations on integers, with
--   a simple data type.
data Expr
  -- | The 'Int' constructor is used to define constant values.
  = Int Int
  -- | The 'Add' constructor is used to add any two expressions together.
  | Add Expr Expr
  deriving Show

-- | Evaluating these expressions is simple.
eval :: Expr -> Int
eval (Int i) = i
eval (Add a b) = eval a + eval b

-- | Load this module in GHCi and see what v1, v2, and v3 evaluate to.
v1 = eval (Int 3)
v2 = eval (Add (Int 4) (Int 5))
v3 = eval (Add (Add (Int 4) (Int 5)) (Int 7))

-- | But what if we want to allow integer *and* boolean expressions?
data ExprProblem
  -- | Use 'I' to define constant integer values.
  = I Int
  -- | Use 'B' to define constant boolean values.
  | B Bool
  -- | Use 'EqP' to compare two expressions for equality.
  | EqP  ExprProblem ExprProblem
  -- | Use 'AddP' to add two expressions together.
  | AddP ExprProblem ExprProblem

-- | This evaluation function can return an integer *or* a boolean value,
--   so its return type must be 'Either Int Bool'; integer values will be
--   returned using the 'Left' constructor, and boolean values will be
--   returned using the 'Right' constructor.
evalpr :: ExprProblem -> Either Int Bool
-- | Evaluation integer and bool constants is simple.
evalpr (I n) = Left n
evalpr (B b) = Right b
-- | Comparing two expressions for equality is also simple.
evalpr (EqP e1 e2) = Right $ (evalpr e1) == (evalpr e2)
-- | But adding two expressions together is complicated, because it is only
--   well-defined when both expressions evaluate to integers.
evalpr (AddP e1 e2) =
  let v1 = evalpr e1
      v2 = evalpr e2
  in
    case (v1, v2) of
      -- If both expressions are integers, return their sum.
      (Left n1, Left n2) -> Left (n1 + n2)
      -- Otherwise, we have a *type error*.
      -- Maybe 'evalpr' should return 'Maybe (Either Int Bool)'?
      _ -> error "Can only add integer expressions"

-- | Load this module in GHCi and see what p1, p2, and p3 evaluate to.
--   Note that evaluating p4 (commented out, below) will throw an error.
p1 = evalpr (EqP (I 3) (I 3))
p2 = evalpr (EqP (I 3) (I 4))
p3 = evalpr (AddP (I 3) (I 4))
-- p4 = evalpr (AddP (I 3) (B True))

-- | We can use Haskell's Generalised Algebraic Data Types (GADT) extension
--   to define a type that handles integer and boolean expressions in a
--   much nicer way. Here, we define the type 'Expr2' that has a type
--   parameter ('a'), which represents the type of value the expression
--   should evaluate to.
data Expr2 a where
  -- | The 'IntExpr' constructor takes one argument (an 'Int') and returns
  --   an expression of type 'Int'.
  IntExpr :: Int -> Expr2 Int
  -- | The 'BoolExpr' constructor takes one argument (a 'Bool') and returns
  --   an expression of type 'Bool'.
  BoolExpr :: Bool -> Expr2 Bool
  -- | The 'AddExpr' constructor takes two *integer expressions* and
  --   returns an integer expression.
  AddExpr :: Expr2 Int -> Expr2 Int -> Expr2 Int
  -- | The 'If' constructor takes a *boolean expression* (the condition)
  --   and two expressions of the *same type* 'a' (the 'then' and 'else'
  --   parts), and returns an expression of type 'a'.
  If :: Expr2 Bool -> Expr2 a -> Expr2 a -> Expr2 a
  -- | Define common boolean operations: and, or, not.
  And :: Expr2 Bool -> Expr2 Bool -> Expr2 Bool
  Or :: Expr2 Bool -> Expr2 Bool -> Expr2 Bool
  Not :: Expr2 Bool -> Expr2 Bool
  -- | Compare two expressions of the same type 'a' for value equality.
  --   Note that this type 'a' must be an instance of the 'Eq' typeclass.
  Eq :: Eq a => Expr2 a -> Expr2 a -> Expr2 Bool

-- | Evaluating these expressions is much simpler than it was for the
--   'ExprProblem' type, because the 'Expr2' type does all of the
--   type-checking for us. For example, it is *impossible* to add an
--   integer expression and a boolean expression.
eval2 :: Expr2 a -> a
eval2 (IntExpr a) = a
eval2 (BoolExpr a) = a
eval2 (AddExpr a b) = (eval2 a) + (eval2 b)
eval2 (If a b c) = if (eval2 a) then (eval2 b) else (eval2 c)
eval2 (And a b) = (eval2 a) && (eval2 b)
eval2 (Or a b) = (eval2 a) || (eval2 b)
eval2 (Not a) = not (eval2 a)
eval2 (Eq a b) = (eval2 a) == (eval2 b)

-- | Load this module in GHCi and see what w1, w2, w3, w4, and w5 evaluate
--   to.
w1 = eval2 $ If (BoolExpr True) (IntExpr 3) (IntExpr 4)
w2 = eval2 $ If (BoolExpr True) (BoolExpr False) (BoolExpr True)
w3 = eval2 $ And (BoolExpr True) (BoolExpr True)
w4 = eval2 $ And (BoolExpr True) (BoolExpr False)
w5 = eval2 $ If (Eq (IntExpr 3) (AddExpr (IntExpr 1) (IntExpr 2)))
     (IntExpr 5) (IntExpr 19)
