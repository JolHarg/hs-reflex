{-# LANGUAGE MonoLocalBinds    #-}
{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo       #-}

module UI.Bootstrap.TabbedNav where

import           Data.Text
import           Reflex.Dom

type Title = Text
type DefaultValue = Text
type TabValue = Text
type ButtonText = Text
type Item m a = (TabValue, ButtonText, m a)
type Items m a = [Item m a]

bsTabbedNav ∷ (MonadWidget t m) ⇒ Title → DefaultValue → Items m a → m [a]
bsTabbedNav theTitle defaultVal items = mdo
    dNav <- holdDyn defaultVal eNavClick
    eNavClick <- divClass "navbar-collapse" .
        elClass "nav" "navbar-expand-lg navbar-light bg-light" .
            elClass "ul" "nav navbar-nav" $ do
                elAttr "a" [
                    ("class", "navbar-brand"),
                    ("href", "javascript:void()")
                    ] $ text theTitle
                buttons <- mapM (\(val, btnText, _) -> do
                    (btn, _) <- elDynAttr' "a" (
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
        divClass "tab-content" $ mapM (\(val, _, content) ->
            elDynAttr "div" (
                (\n -> [
                    ("class", "tab-pane fade" <> if n == val then " show active" else "")
                    ]
                ) <$> dNav
            ) content
        ) items
