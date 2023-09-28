{-# LANGUAGE MonoLocalBinds #-}
-- {-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-type-defaults -Wno-unused-matches -Wno-unused-local-binds #-}

module Main where

-- import           Language.Haskell.TH
import Reflex.Dom
-- import           System.Environment
import UI.Head
import UI.MainWidget

main ∷ IO ()
main = do
    -- let apiHost = $(stringE =<< runIO (getEnv "API_HOST"))
    -- apiHost <- getEnv "API_HOST"
    -- print apiHost
    mainWidgetWithHead htmlHead UI.MainWidget.mainWidget
