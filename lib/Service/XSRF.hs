module Service.XSRF where

import Control.Lens
import Control.Monad.IO.Class
import Data.Text.Encoding     as T
import JSDOM                  (currentDocumentUnchecked)
import JSDOM.Document
import JSDOM.Types            (MonadJSM, liftJSM)
import Reflex.Dom
import Servant.Reflex
import Web.Cookie

xsrfOptions ∷ ClientOptions
xsrfOptions = ClientOptions tweakReq
    where
        tweakReq ∷ MonadJSM m ⇒ XhrRequest a → m (XhrRequest a)
        tweakReq r = do
            -- Get the XHR-COOKIE if set
            let getXsrfToken = lookup "XSRF-TOKEN" . parseCookiesText . T.encodeUtf8
            let getBearerToken = lookup "JWT-Cookie" . parseCookiesText . T.encodeUtf8
            cookie <- liftJSM $ currentDocumentUnchecked >>= getCookie
            let xsrfToken = getXsrfToken cookie
            let bearerToken = getBearerToken cookie
            liftIO . print $ (cookie, xsrfToken, bearerToken)
            -- API access functions
            pure $ r
                & xhrRequest_config
                . xhrRequestConfig_headers
                . at "X-XSRF-TOKEN" .~ xsrfToken
                & xhrRequest_config
                . xhrRequestConfig_headers
                . at "Authorization" .~ (("Bearer " <>) <$> bearerToken)
