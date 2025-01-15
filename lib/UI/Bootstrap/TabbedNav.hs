{-# LANGUAGE MonoLocalBinds    #-}
{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo       #-}

module UI.Bootstrap.TabbedNav where

import Data.Text
import Reflex.Dom

type Title = Text
type DefaultValue = Text
type TabValue = Text
type ButtonText = Text
type Item m a = (TabValue, ButtonText, m a)
type Items m a = [Item m a]

bsTabbedNav ∷ (MonadWidget t m) ⇒ Title → DefaultValue → Items m a → m [a]
bsTabbedNav theTitle defaultVal items = mdo
    dNav <- holdDyn defaultVal eNavClick
    eNavClick <- elClass "nav" "navbar navbar-expand-lg bg-light" $ do
        elClass "div" "container-fluid" $ do
            elAttr "a" [
                ("class", "navbar-brand"),
                ("href", "javascript:void()")
                ] $ text theTitle
            elClass "div" "collapse navbar-collapse" .
                elClass "ul" "navbar-nav" $ do
                    buttons <- traverse (\(val, btnText, _) -> do
                        (btn, _) <- elAttr "li" [
                            ("class", "nav-item")
                            ] . elDynAttr' "a" (
                                (\n -> [
                                    ("class", "nav-link" <> if n == val then " active" else ""),
                                    ("href", "javascript:void()")
                                    ]
                                ) <$> dNav
                            ) $ text btnText
                        pure $ val <$ domEvent Click btn
                        ) items
                    pure $ mconcat buttons
    divClass "row" . divClass "col" .
        divClass "tab-content" $ traverse (\(val, _, content) ->
            elDynAttr "div" (
                (\n -> [
                    ("class", "tab-pane fade" <> if n == val then " show active" else "")
                    ]
                ) <$> dNav
            ) content
        ) items
