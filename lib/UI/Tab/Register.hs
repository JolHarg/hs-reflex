{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE KindSignatures            #-}
{-# LANGUAGE MonoLocalBinds            #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}

module UI.Tab.Register where

import Reflex.Dom
import Types.User
import UI.Bootstrap.Button
import UI.Bootstrap.Form
import UI.Bootstrap.Pane

widgetRegister ∷ MonadWidget t m ⇒ m (Event t (Maybe User))
widgetRegister = smallPane $ do
    el "h2" $ do
        text "Register"
    do
        _dynUsername <- divClass "my-2" $ inputBox "username" "Username" "bob" Prelude.id
        _dynEmail <- divClass "my-2" $ inputBox "email" "Email Address" "bob@bob.com" Prelude.id
        _dynName <- divClass "my-2" $ inputBox "name" "Name" "Bob Frog" Prelude.id
        _dynPassword <- divClass "my-2" $ passwordBox "password" "Password" "abc123" Prelude.id
        _dynPassword2 <- divClass "my-2" $ passwordBox "password2" "Password (again)" "abc123" Prelude.id
        _register <- divClass "my-3" $ bsButton "btn btn-success" "Register"
        pure ()
    pure never
