data NestedList a = Elem a | List [NestedList a]

flatten :: NestedList a -> [a]
-- Wrong use of 'data', must add bracket
-- flatten Elem a      = [a]
flatten (Elem a)      = [a]
flatten (List [])     = []
-- Wrong type, 'flatten' accept one argument whos type is 'NestedList a', but 'xs' is not this type.
-- flatten (List (x:xs)) = (flatten x) ++ (flatten xs)
-- The bracket is not necessary
-- flatten (List (x:xs)) = (flatten x) ++ (flatten (List xs))
flatten (List (x:xs)) = flatten x ++ flatten (List xs)


-----
flat :: NestedList a -> [a]
flat (Elem a) = [a]
flat (List a) = concatMap flat a
