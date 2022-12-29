{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE KindSignatures   #-}

module Service.User where

import           Control.Monad.IO.Class
import           Data.Kind
import           Data.Proxy
import           Reflex.Dom             hiding (Client)
import           Servant.Reflex
import           Service.XSRF
import           Types.API.User

getUser ∷ (MonadIO (Performable m), PerformEvent t m, TriggerEvent t m) ⇒ Client t m GetUserAPI ()
getUser = clientWithOpts
    (Proxy :: Proxy GetUserAPI)
    (Proxy :: Proxy (m :: Type -> Type))
    (Proxy :: Proxy ())
    (constDyn (BasePath "/api/user"))
    xsrfOptions
