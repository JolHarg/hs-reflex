{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE KindSignatures   #-}

module Service.Auth where

import Control.Monad.IO.Class
import Data.Kind
import Data.Proxy
import Reflex.Dom             hiding (Client)
import Servant.Reflex
import Types.API.Auth

login ∷ (MonadIO (Performable m), PerformEvent t m, TriggerEvent t m) ⇒ Client t m LoginAPI ()
login = client
    (Proxy :: Proxy LoginAPI)
    (Proxy :: Proxy (m :: Type → Type))
    (Proxy :: Proxy ())
    (constDyn (BasePath "/api"))

register ∷ (MonadIO (Performable m), PerformEvent t m, TriggerEvent t m) ⇒ Client t m RegisterAPI ()
register = client
    (Proxy :: Proxy RegisterAPI)
    (Proxy :: Proxy (m :: Type → Type))
    (Proxy :: Proxy ())
    (constDyn (BasePath "/api"))

-- verify :: Client t m VerifyAPI ()
-- verify = undefined

-- forgot :: Client t m ForgotAPI ()
-- forgot = undefined
