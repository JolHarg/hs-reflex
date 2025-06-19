{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Modal.Confirm where

import Control.Monad.IO.Class
import Data.Text              (unpack)
import Data.Time.Clock
import Data.UUID.Types
import Reflex.Dom
import Service.Jobs
import System.Random
import Text.Read
import Types.Job              as Job
import Types.Stage            as Stage
import Types.User             as User
import UI.Bootstrap.Button
import UI.Bootstrap.Modal
import UI.Form.Job

modalConfirm ∷ MonadWidget t m ⇒ Dynamic t Bool → Text → m (Event t Bool)
modalConfirm dynModalShown textConfirmation = elDynAttr "div" (modalClasses <$> dynModalShown) .
    modalWrapper $ do
      modalHeader "Confirmation"
      display textConfirmation
      (evtYes, evtNo) <- modalFooter $ do
        evtYes <- bsButton "btn btn-primary" "Yes"
        evtNo <- bsButton "btn btn-secondary" "No"

        pure (evtYes, evtNo)

      pure $ leftmost [
        True <$ evtYes,
        False <$ evtNo
        ]
