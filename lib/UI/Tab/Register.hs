{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE KindSignatures            #-}
{-# LANGUAGE MonoLocalBinds            #-}
{-# LANGUAGE NoMonomorphismRestriction #-}

{-# LANGUAGE OverloadedStrings         #-}


module UI.Tab.Register where

import           Reflex.Dom
import           Types.User
import           UI.Bootstrap.Button
import           UI.Bootstrap.Form

widgetRegister ∷ (MonadWidget t m) ⇒ m (Event t (Maybe User))
widgetRegister = do
    el "h2" $ do
        text "Register"
    do
        _dynUsername <- inputBox "username" "Username" "bob" Prelude.id
        _dynEmail <- inputBox "email" "Email Address" "bob@bob.com" Prelude.id
        _dynName <- inputBox "name" "Name" "Bob Frog" Prelude.id
        _dynPassword <- passwordBox "password" "Password" "abc123" Prelude.id
        _dynPassword2 <- passwordBox "password2" "Password (again)" "abc123" Prelude.id
        _register <- bsButton "btn btn-success" "Register"
        pure ()
    pure never
