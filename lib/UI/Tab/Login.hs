{-# LANGUAGE DataKinds                 #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE KindSignatures            #-}
{-# LANGUAGE MonoLocalBinds            #-}
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
        dynUsername <- divClass "my-2" $ inputBox "username" "Username" "bob" Prelude.id
        dynPassword <- divClass "my-2" $ passwordBox "password" "Password" "abc123" Prelude.id
        let val_username = _inputElement_value dynUsername
        let val_password = _inputElement_value dynPassword
        evtClickLoginButton <- divClass "my-3" $ bsButton "btn btn-success" "Login"

        dynResponse <- holdDyn Nothing $ fmapMaybe (Just . response) loginResult

        _ <- elDynHtmlAttr' "div" [
                ("class", "text-danger")
            ]
            (maybe "" (\response' -> if
            | _xhrResponse_status response' == 500 -> "Sorry, the server is having a tizzy. Maybe try again in a bit."
            | _xhrResponse_status response' == 502 -> "Sorry, the server was unavailable. Maybe try again in a bit."
            | otherwise -> ""
            ) <$> dynResponse)

        let dynCredentials = pure <$> (Login <$> (Username <$> val_username) <*> (Password <$> val_password))

        loginResult <- login dynCredentials evtClickLoginButton

        pure loginResult

    pure $ fmap (getResponse <=< reqSuccess) loginResult'
