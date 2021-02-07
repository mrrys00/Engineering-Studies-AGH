-- 1) Elementarne operacje I/0

:i IO

-- getChar służy do pobierania typu character z prompt
:t getChar
getChar
-- tu wprowadzamy character, ghci od razu go wypluje

let x = getChar -- przypisanie getChar do x

-- putChar służy do pobierania "zza" 
:t putChar
putChar a -- źle
putChar "a" -- źle
:t putChar 'a' -- dobrze
putChar 'a' -- dobrze

-- getLine
:t getLine
getLine
"Hello" -- dobrze

getLine
Hello   -- dobrze

let line = getLine
line
Hello   -- dobrze

-- putStr / putStrLn
:t putStr
putStr "Hello"

:t putStrLn
putStrLn "Hello"    -- to jeszcze wypisze \n na końcu

-- print
print 1 -- dobrze
print a -- źle
print "a" -- dobrze, string
print 'a' -- dobrze, character
print (1,2) -- dobrze
print [1..10] -- dobrze

-- return / show
:t return 'a'   -- return "a" :: Monad m => m [Char]
return 'a'
:t return 1
return 1
:t return "Hello"   -- return "a" :: Monad m => m [Char]
return "Hello"

let hello = return "Hello"
hello
show "Hello"
show hello      -- źle
:t "Hello"
:t hello


-- 2) Łączenie (sekwencje) ‘akcji’ I/O — operatory >> (then) i >>= (bind), notacja do

-- >>
:t (>>) -- (>>) :: Monad m => m a -> m b -> m b
putChar 'a' >> putChar '\n'

actSeq = putChar 'A' >> putChar 'G' >> putChar 'H' >>  putChar '\n'
:t actSeq   -- actSeq :: IO ()
actSeq

-- do
doActSeq = do
  putChar 'A'
  putChar 'G'
  putChar 'H'
  putChar '\n'

:t putChar 'A'
:t putChar '\n'
:t doActSeq
doActSeq    -- AGH

-- >>=
:t (>>=)    -- (>>=) :: Monad m => m a -> (a -> m b) -> m b
:t getLine  -- (>>=) :: Monad m => m a -> (a -> m b) -> m b
:t putStrLn -- (>>=) :: Monad m => m a -> (a -> m b) -> m b
:t getLine >>= putStrLn -- (>>=) :: Monad m => m a -> (a -> m b) -> m b

-- przykład: echo1
echo1 = getLine >>= putStrLn
doEcho1 = do
  line <- getLine
  putStrLn line

:t echo1    -- echo1 :: IO ()
echo1

:t doEcho1  -- doEcho1 :: IO ()
doEcho1

-- przykład: echo2
echo2 = getLine >>= \line -> putStrLn $ line ++ "!"

doEcho2 = do
  line <- getLine
  putStrLn $ line ++ "!"

:t echo2    -- echo2 :: IO ()
echo2

:t doEcho2  -- doEcho2 :: IO ()
doEcho2

-- przykład: echo3
echo3 =  getLine >>= \l1 -> getLine >>= \l2 -> putStrLn $ l1 ++ l2

dialog :: IO ()
dialog = putStr "What is your happy number? "
         >> getLine
         >>= \n -> let num = read n :: Int in
                   if num == 7
                   then putStrLn "Ah, lucky 7!"
                   else if odd num
                        then putStrLn "Odd number! That's most people's choice..."
                        else putStrLn "Hm, even number? Unusual!"

-- 2) Zadania
doEcho3 = do
    line1 <- getLine
    line2 <- getLine 
    putStrLn $ line1 ++ line2

doDialog = do
    putStr "What is your happy number? "
    line <- getLine 
    let num = read line :: Int in     
        if num == 7 then 
            putStrLn "Ah Lucky 7"
        else if odd num then 
            putStrLn "Odd number! That's most people's choice..."
            else 
                putStrLn "Hm, even number? Unusual!"

notDoTwoQuestions = putStr "What is your name? "
            >> getLine >>= \n -> let name = read n :: String in
            putStr "How old are you? "
            >> getLine >>= \n -> let age = read n :: String in 

            print (name,age)

-- działa, sprawdzałem

--3) ‘Akcje’ I/O jako parametry lub wyniki funkcji oraz elementy struktur danych (ćwiczenie opcjonalne)
nTimes :: Int -> IO () -> IO ()
nTimes 0 action = return ()
nTimes n action = do
  action
  nTimes (n-1) action

ioActionFactory :: Int -> String -> IO ()
ioActionFactory n = case n of
  1 -> \name -> putStrLn ("Good morning, " ++ name)
  2 -> \name -> putStrLn ("Good afternoon, " ++ name)
  3 -> \name -> putStrLn ("Good night, " ++ name)
  _ -> \name -> putStrLn ("Hello, " ++ name)

actionList :: [IO ()]
actionList = [ioActionFactory 1 "Ben",
              ioActionFactory 2 "Joe",
              ioActionFactory 3 "Ally"]

sequence'        :: [IO ()] -> IO ()
sequence' []     =  return ()
sequence' (a:as) =  do a
                       sequence' as

nTimes 3 (putStrLn "Hathor")
sequence' [putStrLn "Hathor", putStrLn "Hathor", putStrLn "Hathor"]

sequence' actionList

:t sequence_
sequence_ actionList

:t sequence
sequence actionList

:t sequenceA
sequenceA actionList

-- 3) Zadania
sequence'' as = foldr (>>) (return()) as

class Monad m where
sequence''' as = foldr (\m a -> m b ) (return()) as -- nie działa nie wiem czemu

sequenceIV        :: [IO ()] -> IO ()
sequenceIV []     = return ()
sequenceIV (a:as) = do sequenceIV as
                       a    -- durne spacje i taby

sequenceV         :: [IO ()] -> IO ()
sequenceV as = foldr (>>) (return()) (reverse as)

-- 

-- 5) Funktory 1: operatory fmap, (<$>) i (<$)
-- fmap - prawie jak map
:i Functor
:t fmap (+1)

:i Either
fmap (+2) (Left 3)		-- Left 3
fmap (+2) (Right 3)		-- Right 5

:i []
fmap (*2) [1..5]  -- [2,4,6,8,10]
fmap (*2) []      -- []

:i Maybe
fmap (+1) (Just 3)	-- Just 4
fmap (+1) Nothing	-- Nothing

:i IO
import Data.Char
fmap toUpper getChar

fmap (map toUpper) getLine


:t fmap (+1) (*10)	
fmap (+1) (*10) 1	-- 11

fmap (+1) (0,0)		-- (0, 1)
fmap (+1) (0,0,0)	-- error

-- sam $ do liczb/ funkcji; <$> do tablic itd
:t ($)
:i ($)
(+2) $ 3 			-- 5
(*2) $ (+2) $ 3		-- 10

:t (<$>)
:i (<$>)

(+2) $ (Right 3)	-- error
(+2) <$> (Right 3)	-- Right 5

(*2) <$> [1..5]		-- [2,4,6,8,10]

(+1) <$> (Just 3)	-- Just 4

toUpper <$> getChar	-- powiększ literę

(map toUpper) <$> getLine

(+1) <$> (*10) $ 1	-- 11

(+1) <$> (0,0)		-- (0,1)


:i Functor
:t (<$)

1 <$ Left 2			-- Left 2
1 <$ Right 2		-- Right 1

'a' <$ [1..5]		-- "aaaaa"
'a' <$ []			-- ""

'a' <$ Just 1		-- "a"
'a' <$ Nothing		-- Nothing

42 <$ getLine		-- 42

1 <$ (*10) $ 5		-- 1
:t  1 <$ (*10)		-- 1 <$ (*10) :: (Num a, Num b) => b -> a

1 <$ (0,0)			-- (0,1)
1 <$ (0,0,0)		-- error

-- 6) Funktory 2: dołączanie typów użytkownika do klasy Functor
newtype Box a = MkBox a deriving Show

instance Functor Box where
  fmap f (MkBox x) = MkBox (f x)

:i Box
:i MkBox

fmap (^2) (MkBox 3)	-- 9
1 <$ MkBox 3		-- 1

data MyList a = EmptyList
              | Cons a (MyList a) deriving Show

instance Functor MyList where
	fmap _ EmptyList    = EmptyList
	fmap f (Cons x mxs) = Cons (f x) (fmap f mxs)

fmap (*2) EmptyList		-- EmptyList
let lst1 = Cons 1 (Cons 2 (Cons 3 (Cons 4 EmptyList)))
fmap id lst1			-- Cons 1 (Cons 2 (Cons 3 (Cons 4 EmptyList)))
fmap (const 1) lst1		-- Cons 1 (Cons 1 (Cons 1 (Cons 1 EmptyList)))
fmap (*2) lst1			-- Cons 2 (Cons 4 (Cons 6 (Cons 8 EmptyList)))
fmap odd lst1			-- Cons True (Cons False (Cons True (Cons False EmptyList)))

-- po zakomentowaniu instance Functor MyList dalej generowana jest instancja
-- data MyList a = EmptyList | Cons a (MyList a)
  	-- -- Defined at temp.hs:112:1
-- instance [safe] Show a => Show (MyList a)
  -- -- Defined at temp.hs:113:44

data BinTree a = EmptyBT | NodeBT a (BinTree a) (BinTree a) deriving (Show)

instance Functor BinTree where
	fmap _ EmptyBT			= EmptyBT
	fmap f (NodeBT x lt rt)	= NodeBT (f x) (fmap f lt) (fmap f rt)

-- jak wyżej - po zakomentowaniu fragmentu kodu instancja generowana jest automatycznie
-- data BinTree a = EmptyBT | NodeBT a (BinTree a) (BinTree a)
  	-- -- Defined at temp.hs:119:1
-- instance [safe] Show a => Show (BinTree a)
  -- -- Defined at temp.hs:119:71

-- 7) Funktory aplikatywne 1: operatory pure, (<*>), (*>) i (<*)
:i Applicative

fmap (+1) (Just 1)        -- Just 2
(+1) <$> (Just 1)         -- Just 2
(+) <$> (Just 1) (Just 2) -- error
:t (+) <$> (Just 1)       -- (+) <$> (Just 1) :: Num a => Maybe (a -> a)

-- A function is called pure if it corresponds to a function in the mathematical sense: it associates each possible input value with an output value, and does nothing else. In particular,
-- it has no side effects, that is to say, invoking it produces no observable effect other than the result it returns; it cannot also e.g. write to disk, or print to a screen.
-- it does not depend on anything other than its parameters, so when invoked in a different context or at a different time with the same arguments, it will produce the same result.

(+) <$> (Just 1) <*> (Just 2)		-- Just 3
pure (+) <*> (Just 1) <*> (Just 2)	-- Just 3
:t pure (+) <*> (Just 1)			-- pure (+) <*> (Just 1) :: Num a => Maybe (a -> a)

(\x y z -> x + y + z) <$> Just 1 <*> Just 2 <*> Just 3		-- Just 6
pure (\x y z -> x + y + z) <*> Just 1 <*> Just 2 <*> Just 3 -- Just 6

:i Applicative
:t pure		-- pure :: Applicative f => a -> f a

pure 1 :: Either Int Int		-- Right 1
pure 1 :: Either a Int			-- Right 1
pure 1 :: Either a Double		-- Right 1.0

pure 1 :: [Int]					-- [1]
pure 1 :: [Double]				-- [1.0]

pure 1 :: Maybe Int				-- Just 1
pure 1 :: IO Int				-- 1

pure 1 :: (->) r Int			-- error

pure 1 :: ((,) a Int)			-- error
pure 1 :: Monoid a => ((,) a Int) -- ((), 1)

:t (<*>)						-- (<*>) :: Applicative f => f (a -> b) -> f a -> f b

:i Either
pure (+1) <*> Left 0			-- Left 0
pure (+1) <*> Right 0			-- Right 1
Left (+1) <*> Left 0			-- error
Left (+1) <*> Right 0			-- error
Right (+1) <*> Right 0			-- Right 1
:t pure (+1) <*> Left 0			-- pure (+1) <*> Left 0 :: (Num b, Num a) => Either a b
:t pure (+1) <*> Right 0		-- pure (+1) <*> Right 0 :: Num b => Either a b
:t Left (+1) <*> Left 0			-- Left (+1) <*> Left 0 :: (Num a, Num (a -> a)) => Either (a -> a) b
:t Left (+1) <*> Right 0		-- Left (+1) <*> Right 0 :: Num a => Either (a -> a) b
:t Right (+1) <*> Right 0		-- Right (+1) <*> Right 0 :: Num b => Either a b

:i []
pure (*2) <*> [1..5]			-- [2,4,6,8,10]
:t pure (*2)					-- pure (*2) :: (Applicative f, Num a) => f (a -> a)
:t pure (*2) :: [Int->Int]		-- pure (*2) :: [Int->Int] :: [Int -> Int]
[(+1), (*2)] <*> [1,2,3]		-- [2,3,4,2,4,6]
(*) <$> [1,2,3] <*> [100,101,102]	--	[100,101,102,200,202,204,300,303,306]

import Control.Applicative
:i ZipList
pure (+) <*> ZipList [1,2,3] <*> ZipList [100,100,100]	-- ZipList {getZipList = [101,102,103]}
(+) <$> ZipList [1,2,3] <*> ZipList [100,100..]		-- ZipList {getZipList = [101,102,103]}

let timesList = fmap (*) [1..5]
:t timesList				-- timesList :: (Num a, Enum a) => [a -> a]
fmap (\f -> f 3) timesList	-- [3,6,9,12,15]
(\f -> f 3) <$> timesList	-- [3,6,9,12,15]
($ 3) <$> timesList			-- [3,6,9,12,15]
(:) <*> (\x -> [x]) $ 2		-- [2,2] WTF

(++) <$> Just "Abra" <*> Just "kadabra"						-- Just "Abrakadabra"
(++) <$> Just "Abra" <*> Nothing							-- Nothing
(++) <$> Nothing <*> Just "Abra"							-- Nothing
pure (\x y z -> (x,y,z)) <*> Just 1 <*> Just 2 <*> Just 3	-- Just (1,2,3)
(\x y z -> (x,y,z)) <$> Just 1 <*> Just 2 <*> Just 3		-- Just (1,2,3)

(++) <$> getLine <*> getLine		-- magicznie łączy dwie linijki

(++) <$> (fmap reverse getLine) <*> getLine	-- też magia ale pierwsza od tyłu

:t getLine
:t fmap reverse getLine
(+) <$> (fmap read) getLine <*> (fmap read) getLine		-- ciężko czytać String jako String najwidoczniej
(+) <$> (+1) <*> (*100) $ 5			-- 506 = 5*100 + 5+1
(+) <$> (^2) <*> (^3) $ 3			-- 36 = 3^3 + 3^2

Left 1 *> Left 2	-- Left 1
Right 1 *> Right 2 	-- Right 2

[1..2] *> [11..15]	-- [11,12,13,14,15,11,12,13,14,15]

Just 1 *> Just 5	-- Just 5 - wybierze to z prawej
Nothing *> Just 2	-- Nothing

getLine *> getLine	-- wybierze to z prawej

(+1) *> (*100) $ 5	-- j.w.

Left 1 <* Left 2	-- teraz to z lewej
Right 1 <* Right 2	-- j.w.

[1..2] <* [11..15]	-- [1,1,1,1,1,2,2,2,2,2] - to z lewej powtórzy w ilości z prawej

Just 1 <* Just 2	-- lewa
Just 1 <* Just 2	-- lewa
Just 2 <* Nothing	-- prawa? ooo

getLine <* getLine	-- lewa

(+1) <* (*100) $ 5 	-- lewa

-- 8) Funktory aplikatywne 2: dołączanie typów użytkownika do klasy Applicative

newtype Box a = MkBox a deriving Show

instance Applicative Box where
  pure = MkBox
  (MkBox f) <*> w = fmap f w

instance Functor Box where
  fmap f (MkBox x) = MkBox (f x)

-- 8) Zadania
newtype MyTriple a = MyTriple (a,a,a) deriving Show

instance Functor MyTriple where
	fmap f (MyTriple x) = MyTriple (f (x, x, x))

instance Applicative MyTriple where
	pure = MyTriple
	(MyTriple f) <*> w = fmap f (w, w, w)