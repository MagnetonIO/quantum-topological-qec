{-# LANGUAGE DataKinds, GADTs, TypeOperators #-}

module ProofNormalization (normalizeProof) where

import TypesAndInvariants
import ErrorCorrection

-- A simple normalization: given a qubit with an error, normalize it to the error-free state.
normalizeProof :: Correctable e => Qubit e -> Qubit 'NoError
normalizeProof = correctQubit

-- In a more advanced system, normalization would use type-level rewriting rules.
