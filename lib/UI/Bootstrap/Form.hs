{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Bootstrap.Form where

import Data.Map   (Map)
import Data.Text
import Reflex.Dom

form ∷ MonadWidget t m ⇒ m a → m a
form = elAttr "form" [("class", "needs-validation"), ("no-validate", ""), ("action", "javascript:void()")]

formGroup ∷ MonadWidget t m ⇒ m a → m a
formGroup = divClass "form-group"

inputBoxConfig ∷ Text → Text → InputElementConfig e t s → InputElementConfig e t s
inputBoxConfig id' placeholder = inputElementConfig_elementConfig . elementConfig_initialAttributes .~ [
  ("id", id'),
  ("class", "form-control"),
  ("required", ""),
  ("placeholder", placeholder)
  ]

passwordBoxConfig ∷ Text → Text → InputElementConfig e t s → InputElementConfig e t s
passwordBoxConfig id' placeholder = inputElementConfig_elementConfig . elementConfig_initialAttributes .~ [
  ("id", id'),
  ("type", "password"),
  ("class", "form-control"),
  ("required", ""),
  ("placeholder", placeholder)
  ]

dropdownConfig ∷ Reflex t => Text → Text → DropdownConfig t k → DropdownConfig t k
dropdownConfig id' placeholder = \x -> x & attributes .~ constDyn [
  ("id", id'),
  ("class", "form-control"),
  ("required", ""),
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
    (InputElementConfig EventResult t s → InputElementConfig EventResult t (DomBuilderSpace m)) →
    m (InputElement EventResult (DomBuilderSpace m) t)
passwordBox id' label placeholder config = formGroup $ do
  elAttr "label" [("for", id')] $ text label
  inputElement $ def
    & passwordBoxConfig id' placeholder
    & config

dropdownBox ∷ (MonadWidget t m, Ord k) ⇒ Text → Text → k → Dynamic t (Map k Text) →
    (DropdownConfig t k -> DropdownConfig t k) →
    m (Dropdown t k)
dropdownBox id' label defaultId dynMapIdToValues config = formGroup $ do
  elAttr "label" [("for", id')] $ text label
  dropdown defaultId dynMapIdToValues (def & (dropdownConfig id' "Choose...") . config)
