module MaybeList where

import Test.QuickCheck

quickCheckN   :: (Testable p) => Int -> p -> IO () 
quickCheckN n = quickCheckWith $ stdArgs { maxSuccess = n }

type List a = [a]

dist :: List (Maybe a) -> Maybe (List a)
dist [] = Just []
dist (Nothing:xs) = Nothing
dist (Just x:xs) = dist xs >>= (\l -> return (x:l)) 

maybe_func :: (a -> b) -> (Maybe a) -> (Maybe b)
maybe_func f m = m >>= return.f
       
join_maybe :: Maybe (Maybe a) -> Maybe a
join_maybe m = m >>= id

join_list :: List (List a) -> List a
join_list l = l >>= id

-- Left-most diagrams from the definition:
prop_11 :: List Integer -> Bool
prop_11 l = (dist.(map return) $ l) == return l

prop_12 :: List (Maybe (Maybe Integer)) -> Bool
prop_12 l = (dist.(map join_maybe) $ l) == (join_maybe.(maybe_func dist).dist $ l)

-- Right-most diagrams from the definition:
prop_21 :: Maybe Integer -> Bool
prop_21 m = (maybe_func (return :: Integer -> [Integer]) m) == (dist.return $ m)

prop_22 :: List (List (Maybe Integer)) -> Bool
prop_22 l = (dist.join_list $ l) == ((maybe_func join_list).dist.(map dist) $ l)

returnML :: a -> Maybe (List a)
returnML = return.return

joinML :: Maybe (List (Maybe (List a))) -> Maybe (List a)
joinML =  (maybe_func join_list).join_maybe.(maybe_func dist)

bindML :: Maybe (List a) -> (a -> Maybe (List a)) -> Maybe (List a)
bindML l f = joinML.(maybe_func.map $ f) $ l

