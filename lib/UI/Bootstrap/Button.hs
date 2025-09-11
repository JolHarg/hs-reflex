{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Bootstrap.Button where

import Data.Text
import Reflex.Dom

bsButton ∷ MonadWidget t m ⇒ Text → Text → m (Event t ())
bsButton class' label = do
    (buttonEl, _) <- elAttr' "button" [("class", class')] $ text label
    pure $ domEvent Click buttonEl

bsSubmit ∷ MonadWidget t m ⇒ Text → Text → m (Event t ())
bsSubmit class' label = do
    (buttonEl, _) <- elAttr' "button" [("class", class'), ("type", "submit")] $ text label
    pure $ domEvent Click buttonEl
