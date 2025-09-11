{-# LANGUAGE AllowAmbiguousTypes #-}

module Service.XSRF where

import Control.Lens
import Control.Monad.IO.Class
import Data.Text              qualified as T
import Data.Text.Encoding     as T
import Data.Text.IO           qualified as TIO
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
        tweakReq req = do
            -- Get the XHR-COOKIE if set
            let getXsrfToken = lookup "XSRF-TOKEN" . parseCookiesText . T.encodeUtf8
            let getBearerToken = lookup "JWT-Cookie" . parseCookiesText . T.encodeUtf8
            cookie <- liftJSM $ currentDocumentUnchecked >>= getCookie
            let xsrfToken = getXsrfToken cookie
            let bearerToken = getBearerToken cookie
            -- liftIO . print $ (cookie, xsrfToken, bearerToken)
            -- API access functions
            pure $ req
                & xhrRequest_config
                . xhrRequestConfig_headers
                . at "X-XSRF-TOKEN" .~ xsrfToken
                & xhrRequest_config
                . xhrRequestConfig_headers
                . at "Authorization" .~ (("Bearer " <>) <$> bearerToken)
-- MonadJSM m ⇒
resultHandler ∷ (PerformEvent t m, MonadJSM (Performable m)) => Event t (ReqResult tag' a) → m (Event t (ReqResult tag' a))
resultHandler ev = do
    let pev = liftIO . TIO.putStrLn . showReqResult <$> ev
    performEvent_ pev
    pure ev

showReqResult ∷ ReqResult t a → T.Text
showReqResult (ResponseSuccess _tag' _a _resp) = "ResponseSuccess"
showReqResult (ResponseFailure _tag' text'' _resp) = "ResponseFailure: " <> text''
showReqResult (RequestFailure _tag' text'') = "RequestFailure: " <> text''
