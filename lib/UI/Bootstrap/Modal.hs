{-# LANGUAGE MonoLocalBinds    #-}
{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Bootstrap.Modal where

import Data.Map
import Data.Text
import Reflex.Dom
import UI.Bootstrap.Form

modalWrapper ∷ (MonadWidget t m) ⇒ m a → m a
modalWrapper = divClass "modal-dialog" . divClass "modal-content"

modalHeader ∷ (MonadWidget t m) ⇒ Text → m ()
modalHeader title = divClass "modal-header" . elClass "h5" "modal-title" $ text title

modalBody ∷ (MonadWidget t m) ⇒ m a → m a
modalBody = divClass "modal-body"

modalForm ∷ (MonadWidget t m) ⇒ m a → m a
modalForm = modalBody . form

modalFooter ∷ (MonadWidget t m) ⇒ m a → m a
modalFooter = divClass "modal-footer"

modalClasses ∷ Bool → Map Text Text
modalClasses shown = [
  ("class", "modal fade" <> if shown then " show" else ""),
  ("style", if shown then "display: block" else "")
  ]
