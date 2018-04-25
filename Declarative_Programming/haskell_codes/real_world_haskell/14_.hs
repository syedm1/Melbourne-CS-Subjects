dupli::[a]->[a]
-- learn to use 'concat'
dupli lst = concat [[x,x] | x <- lst]
