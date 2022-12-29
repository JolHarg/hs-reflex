{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE KindSignatures            #-}
{-# LANGUAGE MonoLocalBinds            #-}
{-# LANGUAGE NamedFieldPuns            #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedLists           #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RecursiveDo               #-}
{-# LANGUAGE TemplateHaskell           #-}

module UI.Tab.TH where

import           Data.Map                (Map)
import qualified Data.Map                as M
import           Data.Model
import           Data.Proxy
import           Data.Text               (Text)
import           Data.ToMap.Class
import           Reflex.Dom
import           Service.API
import           Types.API.Companies
import           UI.Bootstrap.Button
import           UI.Modal.Companies.Add
import           UI.Modal.Companies.Edit
import           UI.Table.Companies

widgetTH ∷ (MonadWidget t m) ⇒ Model → (Dynamic t (Map Text (Map Text Text)) →
  m (Dynamic t (Map Text (
    Element EventResult (DomBuilderSpace m) t, [
      (Event t (), Event t Text)
    ]
  )))) → m ()
widgetTH model@Model { modelName, endpoint } tableGen = mdo
  -- remember you can do :<|> in your let
  epb <- getPostBuild

  evtGet <- fmap (fmap (concat . reqSuccess)) . $(get model) $ leftmost [epb]

  dynTableData <- holdDyn [] $ toMap <$> evtGet

  table <- tableGen dynTableData

  pure ()
