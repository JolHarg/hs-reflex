{-# LANGUAGE MultiWayIf                #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedLists           #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RecursiveDo               #-}

module UI.Tab.Login where

import Control.Monad
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

widgetLogin ∷ MonadWidget t m ⇒ m (Event t (Maybe User))
widgetLogin = smallPane $ do
    el "h2" $ do
        text "Login"

    loginResult' <- mdo
        dynLogin <- divClass "my-2" $ inputBox "login" "Username or email address" "bob" Prelude.id
        dynPassword <- divClass "my-2" $ passwordBox "password" "Password" "abc123" Prelude.id
        let val_login = _inputElement_value dynLogin
        let val_password = _inputElement_value dynPassword
        evtClickLoginButton <- divClass "my-3" $ bsButton "btn btn-success" "Login"

        dynResponse <- holdDyn Nothing $ fmapMaybe (Just . response) loginResult

        -- @TODO icon https://getbootstrap.com/docs/5.3/components/alerts/
        void $ elDynHtmlAttr' "div" [
                ("class", "text-danger")
            ]
            (maybe "" (\response' -> if
            -- todo get the message inside and display it if there's something else.
            | _xhrResponse_status response' == 403 -> "Hmm, that doesn't look right..." -- todo you're not allowed in
            | _xhrResponse_status response' == 500 -> "Sorry, the server is having a tizzy. Maybe try again in a bit."
            | _xhrResponse_status response' == 502 -> "Sorry, the server doesn't look like it's running. Maybe try again in a bit."
            | _xhrResponse_status response' == 503 -> "Sorry, the server is too busy. Maybe try again in a bit."
            | otherwise -> ""
            ) <$> dynResponse)

        let dynCredentials = pure <$> ((Login . Username <$> val_login) <*> (Password <$> val_password))

        Service.Auth.login dynCredentials evtClickLoginButton

    pure $ fmap (getResponse <=< reqSuccess) loginResult'
