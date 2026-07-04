{-# LANGUAGE MultiWayIf                #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedLists           #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RecursiveDo               #-}

module UI.Tab.Login where

import Data.Map (Map)
-- import Data.Text qualified as T
import Data.Text (Text)
import Reflex.Dom
import Servant.API
import Servant.Reflex
import Service.Auth
import Types.Login
import Types.Password
import Types.User
import Types.Username
import UI.Bootstrap.Button
import UI.Bootstrap.Form
import UI.Bootstrap.Pane
-- import Web.Cookie

responseToText :: XhrResponse -> Text
responseToText response'
    -- todo get the message inside and display it if there's something else.
    | _xhrResponse_status response' == 401 = "Hmm, that doesn't look right..."
    | _xhrResponse_status response' == 403 = "Whoops, couldn't authorise you."
    | _xhrResponse_status response' == 500 = "Sorry, the server is having a tizzy. Maybe try again in a bit."
    | _xhrResponse_status response' == 502 = "Sorry, the server doesn't look like it's running. Maybe try again in a bit."
    | _xhrResponse_status response' == 503 = "Sorry, the server is too busy. Maybe try again in a bit."
    | otherwise = ""

responseToAlertAttrs :: XhrResponse -> Map Text Text
responseToAlertAttrs response'
    | _xhrResponse_status response' > 400 = [("class", "alert alert-danger"), ("role", "alert")]
    | otherwise = []

widgetLogin ∷ forall t m. MonadWidget t m ⇒ m (Event t (Maybe User))
widgetLogin = smallPane $ mdo
    el "h2" $ do
        text "Log into JobFinder"
    el "p" $ do
        text "Please enter your credentials to enter JobFinder."

    (_form, loginResult') <- form $ mdo
        dynLogin <- divClass "my-2" $ inputBox def {
            inputBoxId = "login",
            inputBoxLabel =  "Username or email address",
            inputBoxPlaceholder = "bob"
        }
        dynPassword <- divClass "my-2" $ inputBox def {
            inputBoxId = "password",
            inputBoxType = "password",
            inputBoxLabel = "Password",
            inputBoxPlaceholder = "abc123"
        }
        let val_login = _inputElement_value dynLogin
        let val_password = _inputElement_value dynPassword
        evtClickLoginButton <- divClass "my-3" . bsSubmit "btn btn-success" $ text "Login"

        dynResponse <- holdDyn Nothing $ fmapMaybe (Just . response) loginResult
        
        -- maybe [] is clearer than foldMap here
        elDynAttr "div" (maybe [] responseToAlertAttrs <$> dynResponse) (dynText (maybe "" responseToText <$> dynResponse))

        let dynCredentials = pure <$> ((Login . Username <$> val_login) <*> (Password <$> val_password))

        loginResult <- Service.Auth.login dynCredentials evtClickLoginButton

        pure loginResult

    el "p" $ do
        elAttr "a" [("href", "#forgot")] $ text "No account?"

    el "p" $ do
        elAttr "a" [("href", "#forgot")] $ text "Forgot your password?"

    pure . fmap getResponse . fmapMaybe reqSuccess $ loginResult'

    -- maybe the result shouldn't be maybe if it's 200 anyway