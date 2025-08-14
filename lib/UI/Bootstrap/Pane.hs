{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}

module UI.Bootstrap.Pane where

import Reflex.Dom

smallPane ∷ (MonadWidget t m) ⇒ m a → m a
smallPane = divClass "col-xl-2 col-lg-4 col-md-6 col-sm-8 offset-xl-5 offset-lg-4 offset-md-3 offset-sm-2"

largePane ∷ (MonadWidget t m) ⇒ m a → m a
largePane = divClass "col-xl-6 col-lg-6 col-md-6 col-sm-8 offset-xl-3 offset-lg-3 offset-md-3 offset-sm-2"
