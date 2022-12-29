{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Table.Cell where

import           Control.Monad (void)
import           Data.Map      as M
import           Data.Text     (Text)
import           Reflex.Dom

tableCellCheckbox ∷ (DomBuilder a m) ⇒ (Text, v → Dynamic a (Map k Text) → m ())
tableCellCheckbox = ("", const . const . void . inputElement $ def & inputElementConfig_elementConfig . elementConfig_initialAttributes .~ [("type", "checkbox")])

tableCellHeaderLink ∷ (DomBuilder a m, PostBuild a m, Ord k) ⇒ t → k → (t, v → Dynamic a (Map k Text) → m ())
tableCellHeaderLink title key = (title, const $ elAttr "a" [("href", "")] . dynText . fmap (M.findWithDefault "(none)" key))

tableCellHeaderFromTo ∷ (DomBuilder a m, PostBuild a m, Ord k) ⇒ t → k → (t, v → Dynamic a (Map k Text) → m ())
tableCellHeaderFromTo title key = (title, const $ dynText . fmap (M.findWithDefault "" key))

tableCellHeaderFrom ∷ (DomBuilder a m, PostBuild a m, Ord k) ⇒ k → (k, v → Dynamic a (Map k Text) → m ())
tableCellHeaderFrom title = (title, const $ dynText . fmap (M.findWithDefault "" title))
