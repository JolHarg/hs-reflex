{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MonoLocalBinds   #-}

module Service.XSRF where

import Control.Lens
import Data.Text.Encoding as T
import GHCJS.DOM          (currentDocumentUnchecked)
import GHCJS.DOM.Document
import GHCJS.DOM.Types    (liftJSM)
import Reflex.Dom
import Servant.Reflex
import Web.Cookie

xsrfOptions ∷ ClientOptions
xsrfOptions = ClientOptions tweakReq
    where tweakReq r = do
            -- Get the XHR-COOKIE if set
            let getToken = lookup "XSRF-TOKEN" . parseCookiesText . T.encodeUtf8
            xsrfToken <- liftJSM $ getToken <$> (currentDocumentUnchecked >>= getCookie)

            -- API access functions
            pure $ r & xhrRequest_config
                . xhrRequestConfig_headers
                . at "X-XSRF-TOKEN" .~ xsrfToken
