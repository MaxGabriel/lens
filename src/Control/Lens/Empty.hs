{-# LANGUAGE CPP #-}
{-# LANGUAGE MagicHash #-}

#ifdef DEFAULT_SIGNATURES
{-# LANGUAGE DefaultSignatures #-}
#endif
-------------------------------------------------------------------------------
-- |
-- Module      :  Control.Lens.Empty
-- Copyright   :  (C) 2012-13 Edward Kmett
-- License     :  BSD-style (see the file LICENSE)
-- Maintainer  :  Edward Kmett <ekmett@gmail.com>
-- Stability   :  provisional
-- Portability :  non-portable
--
-------------------------------------------------------------------------------
module Control.Lens.Empty
  (
    AsEmpty(..)
  ) where

import Control.Lens.Prism
import Control.Lens.Review
import Data.ByteString as StrictB
import Data.ByteString.Lazy as LazyB
import Data.HashMap.Lazy as HashMap
import Data.HashSet as HashSet
import Data.IntMap as IntMap
import Data.IntSet as IntSet
import Data.Map as Map
import Data.Maybe
import Data.Monoid
import Data.Profunctor
import Data.Sequence as Seq
import Data.Set as Set
import Data.Text as StrictT
import Data.Text.Lazy as LazyT
import Data.Vector as Vector
import Data.Vector.Unboxed as Unboxed
import Data.Vector.Storable as Storable
import GHC.Event

class AsEmpty a where
  -- |
  --
  -- >>> isn't _Empty [1,2,3]
  -- True
  _Empty :: Prism' a ()
#ifndef HLINT
#ifdef DEFAULT_SIGNATURES
  default _Empty :: (Monoid a, Eq a) => Prism' a ()
  _Empty = only mempty
#endif
#endif

instance AsEmpty Ordering where
  _Empty = only mempty
  {-# INLINE _Empty #-}

instance AsEmpty () where
  _Empty = only mempty
  {-# INLINE _Empty #-}

instance AsEmpty Any where
  _Empty = only mempty
  {-# INLINE _Empty #-}

instance AsEmpty All where
  _Empty = only mempty
  {-# INLINE _Empty #-}

instance AsEmpty Event where
  _Empty = only mempty
  {-# INLINE _Empty #-}

instance AsEmpty (Maybe a) where
  _Empty = _Nothing
  {-# INLINE _Empty #-}

instance AsEmpty (Last a) where
  _Empty = nearly (Last Nothing) (isNothing . getLast)
  {-# INLINE _Empty #-}

instance AsEmpty (First a) where
  _Empty = nearly (First Nothing) (isNothing . getFirst)
  {-# INLINE _Empty #-}

instance (Eq a, Num a) => AsEmpty (Product a) where
  _Empty = only mempty
  {-# INLINE _Empty #-}

instance (Eq a, Num a) => AsEmpty (Sum a) where
  _Empty = only mempty
  {-# INLINE _Empty #-}

instance AsEmpty a => AsEmpty (Dual a) where
  _Empty = dimap getDual (fmap Dual) . _Empty
  {-# INLINE _Empty #-}

instance (AsEmpty a, AsEmpty b) => AsEmpty (a,b) where
  _Empty = prism (\() -> (_Empty # (), _Empty # ())) $ \(s,s') -> case _Empty Left s of
    Left () -> case _Empty Left s' of
      Left () -> Right ()
      Right t' -> Left (_Empty # (), t')
    Right t -> Left (t, _Empty # ())
  {-# INLINE _Empty #-}

instance (AsEmpty a, AsEmpty b, AsEmpty c) => AsEmpty (a,b,c) where
  _Empty = prism (\() -> (_Empty # (), _Empty # (), _Empty # ())) $ \(s,s',s'') -> case _Empty Left s of
    Left () -> case _Empty Left s' of
      Left () -> case _Empty Left s'' of
        Left () -> Right ()
        Right t'' -> Left (_Empty # (), _Empty # (), t'')
      Right t'    -> Left (_Empty # (), t', _Empty # ())
    Right t       -> Left (t, _Empty # (), _Empty # ())
  {-# INLINE _Empty #-}

instance AsEmpty [a] where
  _Empty = nearly [] Prelude.null
  {-# INLINE _Empty #-}

instance AsEmpty (Map k a) where
  _Empty = nearly Map.empty Map.null
  {-# INLINE _Empty #-}

instance AsEmpty (HashMap k a) where
  _Empty = nearly HashMap.empty HashMap.null
  {-# INLINE _Empty #-}

instance AsEmpty (IntMap a) where
  _Empty = nearly IntMap.empty IntMap.null
  {-# INLINE _Empty #-}

instance AsEmpty (Set a) where
  _Empty = nearly Set.empty Set.null
  {-# INLINE _Empty #-}

instance AsEmpty (HashSet a) where
  _Empty = nearly HashSet.empty HashSet.null
  {-# INLINE _Empty #-}

instance AsEmpty IntSet where
  _Empty = nearly IntSet.empty IntSet.null
  {-# INLINE _Empty #-}

instance AsEmpty (Vector.Vector a) where
  _Empty = nearly Vector.empty Vector.null
  {-# INLINE _Empty #-}

instance Unbox a => AsEmpty (Unboxed.Vector a) where
  _Empty = nearly Unboxed.empty Unboxed.null
  {-# INLINE _Empty #-}

instance Storable a => AsEmpty (Storable.Vector a) where
  _Empty = nearly Storable.empty Storable.null
  {-# INLINE _Empty #-}

instance AsEmpty (Seq a) where
  _Empty = nearly Seq.empty Seq.null
  {-# INLINE _Empty #-}

instance AsEmpty StrictB.ByteString where
  _Empty = nearly StrictB.empty StrictB.null
  {-# INLINE _Empty #-}

instance AsEmpty LazyB.ByteString where
  _Empty = nearly LazyB.empty LazyB.null
  {-# INLINE _Empty #-}

instance AsEmpty StrictT.Text where
  _Empty = nearly StrictT.empty StrictT.null
  {-# INLINE _Empty #-}

instance AsEmpty LazyT.Text where
  _Empty = nearly LazyT.empty LazyT.null
  {-# INLINE _Empty #-}