module Service.User where

import Data.Kind
import Data.Proxy
import JSDOM.Types    (MonadJSM)
import Reflex.Dom     hiding (Client)
import Servant.Reflex
import Service.XSRF
import Types.API.User

getUser ∷ (MonadJSM (Performable m), PerformEvent t m, TriggerEvent t m) ⇒ Client t m GetUserAPI ()
getUser = clientWithOpts
    (Proxy :: Proxy GetUserAPI)
    (Proxy :: Proxy (m :: Type → Type))
    (Proxy :: Proxy ())
    (constDyn (BasePath "/api/user"))
    xsrfOptions
