data Font_color
    = Color_name String
    | Hex Int
    | RGB Int Int Int
    deriving Show

type Font_tag = [Font]
data Font 
    = Size Int
    | Face Int 
    | Font_color Font_color
