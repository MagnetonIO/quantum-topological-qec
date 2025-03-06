{-# LANGUAGE DataKinds, GADTs, TypeOperators, FlexibleInstances, MultiParamTypeClasses #-}

module FunctorialMapping (ErrorFunctor(..), mapError) where

import TypesAndInvariants
import ErrorCorrection

-- Define a functor class that maps from a local error state to a corrected invariant.
class ErrorFunctor f where
  fmapError :: (Correctable e) => f e -> Qubit 'NoError

-- Our local error functor wraps a qubit.
newtype LocalError e = LocalError { getQubit :: Qubit e }

instance ErrorFunctor LocalError where
  fmapError (LocalError q) = correctQubit q

-- A helper function to perform the mapping.
mapError :: (ErrorFunctor f, Correctable e) => f e -> Qubit 'NoError
mapError = fmapError
