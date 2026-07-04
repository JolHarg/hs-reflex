{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Bootstrap.Form where

import Data.Default
import Data.Map   (Map)
import Data.Text
import Reflex.Dom

form ∷ MonadWidget t m ⇒ m a → m (El t, a)
form = elAttr' "form" [("class", "needs-validation"), ("no-validate", ""), ("action", "javascript:void()"), ("accept-charset", "utf-8")]

formGroup ∷ MonadWidget t m ⇒ m a → m a
formGroup = divClass "form-group"

dropdownConfig ∷ Reflex t => Text → Text → DropdownConfig t k → DropdownConfig t k
dropdownConfig id' placeholder = \x -> x & attributes .~ constDyn [
  ("id", id'),
  ("class", "form-control"),
  ("required", ""),
  ("placeholder", placeholder)
  ]
  
data InputBoxOptions t m = InputBoxOptions {
  inputBoxId :: Text,
  inputBoxType :: Text,
  inputBoxIcon :: Maybe (m ()),
  inputBoxLabel :: Text,
  inputBoxPlaceholder :: Text,
  inputBoxConfigOptions :: InputElementConfig EventResult t (DomBuilderSpace m) → InputElementConfig EventResult t (DomBuilderSpace m)
}

instance Default (InputBoxOptions t m) where
  def = InputBoxOptions {
    inputBoxId = "",
    inputBoxType = "text",
    inputBoxIcon = Nothing,
    inputBoxLabel = "",
    inputBoxPlaceholder = "",
    inputBoxConfigOptions = id
  }

inputBox ∷ (MonadWidget t m) ⇒ InputBoxOptions t m → m (InputElement EventResult (DomBuilderSpace m) t)
inputBox InputBoxOptions { inputBoxId = id', inputBoxType = inputType, inputBoxIcon = icon, inputBoxLabel = label, inputBoxPlaceholder = placeholder, inputBoxConfigOptions = config } = formGroup $ do
  elAttr "label" [("for", id')] $ do
    case icon of
      Nothing -> blank
      Just icon' -> do
        icon'
        text " "
    text label
  inputElement $ def
    & inputElementConfig_elementConfig . elementConfig_initialAttributes .~ [
        ("id", id'),
        ("type", inputType),
        ("class", "form-control"),
        ("required", ""),
        ("placeholder", placeholder)
        ]
    & config

dropdownBox ∷ (MonadWidget t m, Ord k) ⇒ Text → Text → k → Dynamic t (Map k Text) →
    (DropdownConfig t k -> DropdownConfig t k) →
    m (Dropdown t k)
dropdownBox id' label defaultId dynMapIdToValues config = formGroup $ do
  elAttr "label" [("for", id')] $ text label
  dropdown defaultId dynMapIdToValues (def & (dropdownConfig id' "Choose...") . config)

checkbox' ∷ MonadWidget t m ⇒ m (InputElement EventResult (DomBuilderSpace m) t)
checkbox' = inputElement $ def & inputElementConfig_elementConfig
  . elementConfig_initialAttributes
  .~ [("type", "checkbox")]