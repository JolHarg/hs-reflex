{-# LANGUAGE TemplateHaskell #-}

module Service.TH where

import Data.Kind
import Data.Model
import Data.Proxy
import Language.Haskell.TH
import Servant.Reflex

get ∷ Model → Q Exp
get Model { singularType } = [|
  client
    (Proxy :: Proxy $(conT . mkName $ ("Get" <> singularType)))
    (Proxy :: Proxy (m :: Data.Kind.Type → Data.Kind.Type))
    (Proxy :: Proxy ())
    (constDyn (BasePath $ "https//api.jobfinder.jolharg.com/api/" <> singularEndpoint))
  |]
