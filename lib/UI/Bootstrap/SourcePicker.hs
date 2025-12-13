{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Bootstrap.SourcePicker (renderPicker, RenderPickerOptions(..)) where

import Data.Foldable
import Data.Text           (Text)
import Reflex.Dom
import UI.Icon.FontAwesome

renderIsPrimary :: MonadWidget t m => m ()
renderIsPrimary = el "em" $ text "Primary"

renderIsSecondary :: MonadWidget t m => m ()
renderIsSecondary = elAttr "a" [("href", "javascript:void()")] $ text "Make primary"

renderExistingLine :: MonadWidget t m => Bool -> Text -> m ()
renderExistingLine isPrimary name = do
  elAttr "div" [("class", "row p-2")] $ do
    elAttr "div" [("class", "col-md-6")] $ do
      elAttr "span" [] $ text name
    elAttr "div" [("class", "col-md-4")] $ do
      if isPrimary
        then renderIsPrimary
        else renderIsSecondary
    elAttr "div" [("class", "col-md-2 text-end")] $ do
      elAttr "button" [("class", "btn btn-warning")] $ iconS "edit"
      elAttr "button" [("class", "btn btn-danger")] $ iconS "trash-alt"

renderEditing ∷ MonadWidget t m ⇒ Text → Text → m ()
renderEditing editPlaceholder editing = do
  elAttr "div" [("class", "row p-2")] $ do
    elAttr "div" [("class", "col-md-10")] $ do
      elAttr "input" [("class", "form-control"), ("placeholder", editPlaceholder), ("value", editing)] blank
    elAttr "div" [("class", "col-md-2 text-end")] $ do
      elAttr "button" [("class", "btn btn-success")] $ iconS "save"
      elAttr "button" [("class", "btn btn-danger")] $ iconS "times"

renderNew ∷ MonadWidget t m ⇒ Text → m ()
renderNew newPlaceholder = do
  elAttr "div" [("class", "row p-2")] $ do
    elAttr "div" [("class", "col-md-10")] $ do
      elAttr "input" [("class", "form-control"), ("placeholder", newPlaceholder)] blank
    elAttr "div" [("class", "col-md-2 text-end")] $ do
      elAttr "button" [("class", "btn btn-secondary")] $ iconS "plus-circle"

renderPickerBody ∷ MonadWidget t m ⇒ Int → [Text] → Text → Text → Text → m ()
renderPickerBody primaryIdx entries editPlaceholder editingText newPlaceholder = do
  elAttr "div" [("class", "row p-0")] $ do
    elAttr "div" [("class", "col-md-12")] $ do
      for_ (zip [0..] entries) $ \(entryIdx, entryText) -> do
         renderExistingLine (entryIdx == primaryIdx) entryText
      renderEditing editPlaceholder editingText
      renderNew newPlaceholder

{-}
data SimpleSource idType nameType = SimpleSource {
    sourceId :: idType,
    sourceName :: nameType
}
data SimpleEntity = SimpleEntity {

}
-}

-- 

data RenderPickerOptions t m = RenderPickerOptions {
    icon :: m (),
    name :: Text,
    primaryIdx :: Int,
    entries :: [Text],
    editPlaceholder :: Text,
    editingText :: Text,
    newPlaceholder :: Text
}

renderPicker ∷ MonadWidget t m ⇒ RenderPickerOptions t m → m ()
renderPicker RenderPickerOptions { icon, name, primaryIdx, entries, editPlaceholder, editingText, newPlaceholder } = do
  elAttr "fieldset" [("class", "form-group row p-1")] $ do
    elAttr "div" [("class", "row")] $ do
      elAttr "legend" [("class", "col-form-label")] $ do
        icon
        text " "
        text name
      renderPickerBody primaryIdx entries editPlaceholder editingText newPlaceholder
