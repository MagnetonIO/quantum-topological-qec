{-# LANGUAGE DataKinds, GADTs, TypeOperators, KindSignatures #-}

module PenaltyTerms (Penalty(..), applyPenalty, correctWithPenalty, QubitWithPenalty(..)) where

import TypesAndInvariants
import ErrorCorrection

-- | A wrapper type that pairs a quantum state with its associated energy penalty.
data QubitWithPenalty (e :: ErrorState) where
  QubitWithPenalty :: Double -> Qubit e -> QubitWithPenalty e

-- | The 'Penalty' type class associates an energy penalty with a given quantum state.
class Penalty a where
  penalty :: a -> Double

-- | Instances for different error states.
instance Penalty (Qubit 'NoError) where
  penalty _ = 0.0

instance Penalty (Qubit 'ZError) where
  penalty _ = 5.0  -- Arbitrary penalty value for a Z error

instance Penalty (Qubit 'XError) where
  penalty _ = 4.0  -- Arbitrary penalty value for an X error

instance Penalty (Qubit 'YError) where
  penalty _ = 6.0  -- Arbitrary penalty value for a Y error

-- | Compute the penalty for a QubitWithPenalty by combining its stored penalty with the inherent penalty.
applyPenalty :: (Penalty (Qubit e)) => QubitWithPenalty e -> Double
applyPenalty (QubitWithPenalty storedPenalty q) = storedPenalty + penalty q

-- | Correct a qubit with an error while reporting its penalty.
-- This function returns a tuple containing the corrected, error-free qubit along with its associated penalty.
correctWithPenalty :: (Penalty (Qubit e), Correctable e) => QubitWithPenalty e -> (Qubit 'NoError, Double)
correctWithPenalty (QubitWithPenalty storedPenalty q) = 
  let p = storedPenalty + penalty q
      corrected = correctQubit q
  in (corrected, p)

-- | Example constructor for a QubitWithPenalty.
-- Here, we assign an initial stored penalty (e.g., from an external process) to the qubit.
makeQubitWithPenalty :: (Penalty (Qubit e)) => Qubit e -> Double -> QubitWithPenalty e
makeQubitWithPenalty q initialPenalty = QubitWithPenalty initialPenalty q
