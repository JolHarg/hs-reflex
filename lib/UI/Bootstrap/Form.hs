{-# LANGUAGE MonoLocalBinds    #-}
{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Bootstrap.Form where

import           Data.Text
import           Reflex.Dom

form ∷ (MonadWidget t m) ⇒ m a → m a
form = el "form"

formGroup ∷ (MonadWidget t m) ⇒ m a → m a
formGroup = divClass "form-group"

inputBoxConfig ∷ Text → Text → InputElementConfig e t s → InputElementConfig e t s
inputBoxConfig id' placeholder = inputElementConfig_elementConfig . elementConfig_initialAttributes .~ [
  ("id", id'),
  ("class", "form-control"),
  ("placeholder", placeholder)
  ]

passwordBoxConfig ∷ Text → Text → InputElementConfig e t s → InputElementConfig e t s
passwordBoxConfig id' placeholder = inputElementConfig_elementConfig . elementConfig_initialAttributes .~ [
  ("id", id'),
  ("type", "password"),
  ("class", "form-control"),
  ("placeholder", placeholder)
  ]

inputBox ∷ (DomSpace s, MonadWidget t m) ⇒ Text → Text → Text →
    (InputElementConfig EventResult t s → InputElementConfig EventResult t GhcjsDomSpace) →
    m (InputElement EventResult (DomBuilderSpace m) t)
inputBox id' label placeholder config = formGroup $ do
  elAttr "label" [("for", id')] $ text label
  inputElement $ def
    & inputBoxConfig id' placeholder
    & config

passwordBox ∷ (DomSpace s, MonadWidget t m) ⇒ Text → Text → Text →
    (InputElementConfig EventResult t s → InputElementConfig EventResult t GhcjsDomSpace) →
    m (InputElement EventResult (DomBuilderSpace m) t)
passwordBox id' label placeholder config = formGroup $ do
  elAttr "label" [("for", id')] $ text label
  inputElement $ def
    & passwordBoxConfig id' placeholder
    & config
