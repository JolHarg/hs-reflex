{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Icon.FontAwesome where

import Data.Text  (Text)
import Reflex.Dom

iconS ∷ MonadWidget t m ⇒ Text → m ()
iconS name = elAttr "i" [("class", "fas fa-" <> name)] $ blank

iconB ∷ MonadWidget t m ⇒ Text → m ()
iconB name = elAttr "i" [("class", "fab fa-" <> name)] $ blank
