{-# LANGUAGE MonoLocalBinds    #-}
{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Head where

import Data.Text
import Reflex.Dom

htmlHead ∷ MonadWidget t m ⇒ m ()
htmlHead = do
  elAttr
    "link"
    [ ("href", "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"),
      ("rel", "stylesheet"),
      ("integrity", "sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"),
      ("crossorigin", "anonymous")
    ]
    blank
  elAttr
    "link"
    [ ("href", "/css/index.css"),
      ("rel", "stylesheet")
    ]
    blank
  elAttr
    "link"
    [ ("href", "/img/jh.png"),
      ("rel", "shortcut icon")
    ]
    blank
  elAttr
    "meta"
    [ ("charset", "utf-8")
    ]
    blank
  elAttr "meta" [("http-equiv", "X-Who-Is-Awesome: Raven")] blank
  mapM_ (\(name', content') -> elAttr "meta" [("name", name'), ("content", content')] blank) ([
    ("description", "JolHarg JobFinder helps you find and organise jobs."),
    -- ("keywords", intercalate "," ["jolharg", "jobfinder"]),
    ("Content-Type", "text/html; charset=utf-8"),
    ("X-Who-Is-Baby", "Raven"),
    ("X-UA-Compatible", "IE=edge,chrome=1"),
    ("viewport", "width=device-width, initial-scale=1"),
    ("favicon", "/jh.png")
    ] :: [(Text, Text)])
  el "title" $ text "JobFinder"
