{-# LANGUAGE DataKinds, GADTs, TypeOperators, FlexibleInstances #-}

module ErrorCorrection (correctQubit, Correctable(..)) where

import TypesAndInvariants

-- Type class for correctable states
class Correctable (e :: ErrorState) where
  correct :: Qubit e -> Qubit 'NoError

instance Correctable 'NoError where
  correct Qubit = Qubit

-- For this proof-of-concept, any error state is corrected to NoError.
instance Correctable 'ZError where
  correct _ = Qubit

instance Correctable 'XError where
  correct _ = Qubit

instance Correctable 'YError where
  correct _ = Qubit

-- A wrapper function to correct any qubit if possible.
correctQubit :: Correctable e => Qubit e -> Qubit 'NoError
correctQubit = correct
