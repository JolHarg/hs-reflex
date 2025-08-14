{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedLists           #-}
{-# LANGUAGE OverloadedStrings         #-}

module UI.Tab.Register where

import Control.Lens
import Reflex.Dom
import Types.User
import UI.Bootstrap.Button
import UI.Bootstrap.Form
import UI.Bootstrap.Pane

widgetRegister ∷ MonadWidget t m ⇒ m (Event t (Maybe User))
widgetRegister = largePane $ do
    el "h1" $ text "Register for JobFinder"
    el "p" $ text "Thank you for choosing to register with JobFinder. Please fill in your details below so we can get you into our system:"
    form $ do -- checkValidity() -> add was-validated class for JS classes
        _dynUsername <- formGroup . divClass "my-2" $ inputBox "username" "Username *" "bob" Prelude.id -- TODO add is-invalid from server
            -- here in small red: optional error, cover box with red border
        _dynEmail <- formGroup $ do
            input <- divClass "my-3" $ inputBox "email" "Email Address *" "bob@bob.com" ( -- TODO add is-invalid from server
                inputElementConfig_elementConfig . elementConfig_initialAttributes <>~ [
                    ("type", "email")
                    ]
                )
            elAttr "small" [("id", "emailHelp"), ("class", "form-text text-muted")] $
                text "We'll never share your email with anyone else."
            divClass "invalid-feedback" $ text "There is already a user with this username."
            pure input
        _dynFullName <- formGroup $ do
            input <- divClass "my-3" $ inputBox "fullName" "Full Name *" "Bob Frog" Prelude.id -- TODO add is-invalid from server
            divClass "invalid-feedback" $ text "You must provide this field."
            pure input
        _dynGivenName <- formGroup $ do
            input <- divClass "my-3" $ inputBox "givenName" "What should we should call you?" "Bob" Prelude.id
            elAttr "small" [("id", "given_name_help"), ("class", "form-text text-muted")] $
                text "This will only be used to address you in communication, and defaults to your full name if you don't enter anything."
            pure input
        _dynPassword <- formGroup $ do
            input <- divClass "my-3" $ passwordBox "password" "Password *" "A_R3ally_s3cure_pa$$word!" Prelude.id
            elAttr "small" [("id", "password_help"), ("class", "form-text text-muted")] $
                text "This must be a secure password, 12 characters or above, with more than 2 of each upper and lowercase letters, digits and symbols."
            divClass "invalid-feedback" $ text "That's not secure enough; this password must match the requirements."
            divClass "invalid-feedback" $ text "That's not secure enough; this password was found in a leak!"
            pure input
        _dynPassword2 <- formGroup $ do
            input <- divClass "my-3" $ passwordBox "password2" "Password (again) *" "A_R3ally_s3cure_pa$$word!" Prelude.id
            divClass "invalid-feedback" $ text "This password must match the password above."
            pure input
        el "hr" blank
        _dynAgreeToTerms <- formGroup $ do
            divClass "form-check" $ do
                input <- inputElement $ def & inputElementConfig_elementConfig . elementConfig_initialAttributes .~ [
                    ("id", "agreeToTerms"),
                    ("type", "checkbox"),
                    ("value", ""),
                    ("class", "form-check-input"),
                    ("required", "")
                    ]
                elAttr "label" [("class", "form-check-label"), ("for", "agreeToTerms")] $ do
                    text "I agree to the "
                    elAttr "a" [("href", "/terms-and-conditions"), ("target", "_blank")] $ text "terms and conditions -^"
                    text " *"
                divClass "invalid-feedback" $ text "You must agree to the terms and conditions before submitting."
                pure input
        _dynAgreeToPrivacyPolicy <- formGroup $ do
            divClass "form-check" $ do
                input <- inputElement $ def & inputElementConfig_elementConfig . elementConfig_initialAttributes .~ [
                    ("id", "agreeToPrivacyPolicy"),
                    ("type", "checkbox"),
                    ("value", ""),
                    ("class", "form-check-input"),
                    ("required", "")
                    ]
                elAttr "label" [("class", "form-check-label"), ("for", "agreeToPrivacyPolicy")] $ do
                    text "I agree to the "
                    elAttr "a" [("href", "/privacy-policy"), ("target", "_blank")] $ text "privacy policy -^"
                    text " *"
                divClass "invalid-feedback" $ text "You must agree to the terms and conditions before submitting."
                pure input
        el "hr" blank
        _dynRegisterButton <- formGroup $ do
            divClass "my-3" $ bsButton "btn btn-success" "Register"
        -- here comes a reasonable place for non form specific errors
        pure ()
    pure never
