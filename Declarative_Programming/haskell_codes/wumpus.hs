data Cmd = W|E|N|S|Shoot
    deriving (Eq,Show)

robot :: (Int,Int) -> [Cmd] -> [(Int,Int,Cmd)]
robot (x,y) cmd = map (\(a,b,c,d)->(a,b,c)) $ filter (\(a,b,c,d)->d==Shoot) $ robot' (x,y,N) cmd

robot' :: (Int,Int,Cmd) -> [Cmd] -> [(Int,Int,Cmd,Cmd)]
robot' _ [] = []
robot' (x,y,cmd) (c:cs) = (x,y,cmd,c) : robot' (dir (x,y,cmd) c) cs

dir :: (Int,Int,Cmd) -> Cmd -> (Int,Int,Cmd)
dir (x,y,z) Shoot = (x,y,z)
dir (x,y,z) S = (x,y-1,z)
dir (x,y,z) N = (x,y+1,z)
dir (x,y,z) E = (x+1,y,z)
dir (x,y,z) W = (x-1,y,z)

